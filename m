Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99194C4338F
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 08:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7596061052
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 08:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhHFIel (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 04:34:41 -0400
Received: from lgeamrelo11.lge.com ([156.147.23.51]:38089 "EHLO
        lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhHFIek (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 04:34:40 -0400
X-Greylist: delayed 1799 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2021 04:34:40 EDT
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
        by 156.147.23.51 with ESMTP; 6 Aug 2021 17:04:23 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: byungchul.park@lge.com
Received: from unknown (HELO X58A-UD3R) (10.177.222.33)
        by 156.147.1.126 with ESMTP; 6 Aug 2021 17:04:23 +0900
X-Original-SENDERIP: 10.177.222.33
X-Original-MAILFROM: byungchul.park@lge.com
Date:   Fri, 6 Aug 2021 17:03:44 +0900
From:   Byungchul Park <byungchul.park@lge.com>
To:     torvalds@linux-foundation.org, peterz@infradead.org,
        mingo@redhat.com, will@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        rostedt@goodmis.org, joel@joelfernandes.org,
        alexander.levin@microsoft.com, daniel.vetter@ffwll.ch,
        chris@chris-wilson.co.uk, duyuyang@gmail.com,
        johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
        willy@infradead.org, david@fromorbit.com, amir73il@gmail.com,
        bfields@fieldses.org, gregkh@linuxfoundation.org,
        kernel-team@lge.com
Subject: [REPORT] Request for reviewing crypto code wrt wait_for_completion()
Message-ID: <20210806080344.GA5788@X58A-UD3R>
References: <20210803021611.GA28236@X58A-UD3R>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803021611.GA28236@X58A-UD3R>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello crypto folks,

I developed a tool for tracking waiters and reporting if any of the
events that the waiters are waiting for would never happen, say, a
deadlock. Yes, it would look like Lockdep but more inclusive.

While I ran the tool(Dept: Dependency Tracker) on v5.4.96, I got some
reports from the tool. One of them is related to crypto subsystem.
Because I'm not that familiar with the code, I'd like to ask you guys to
review the related code.

If I understand correctly, it doesn't actually cause deadlock but looks
like a problematic code. I know you are not used to the format of the
report from Dept so.. let me summerize the result.

The simplified call trace looks like when the problem araised :

THREAD A
--------
A1 crypto_alg_mod_lookup()
A2    crypto_probing_notify(CRYPTO_MSG_ALG_REQUEST)
A3       cryptomgr_schedule_probe()
A4          kthread_run(cyptomgr_probe) ---> Start THREAD B

A5    crypto_larval_wait()
A6       wait_for_completion_killable_timeout(c) /* waiting for B10 */

THREAD B
--------
B1 cryptomgr_probe()
B2    pkcslpad_create()
B3       crypto_wait_for_test()
B4          crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER)
B5             cryptomgr_schedule_test()
B6                kthread_run(cyptomgr_test) ---> Start THREAD C

B7    tmpl->alloc()
B8    crupto_register_instance()
B9          wait_for_completion_killable(c) /* waiting for C3 */
B10   complete_all(c)

THREAD C
--------
C1 cryptomgr_test()
C2    crypto_alg_tested()
C3       complete_all(c)

---

For example, in this situation, I think C3 could wake up both A6 and B9
before THREAD B reaches B10 which is not desired by A6. Say, is it okay
to wake up A6 with B7 ~ B9 having yet to complete?

Sorry if I misunderstand the code. It looks so complicated to me. Could
you check if the code is good?

Just FYI, the below is the report from the tool, Dept, I developed.

Thanks,
Byungchul

---

[   10.520128 ] ===================================================
[   10.526037 ] Dept: Circular dependency has been detected.
[   10.531337 ] 5.4.96-242 #1 Tainted: G        W   
[   10.536375 ] ---------------------------------------------------
[   10.542280 ] summary
[   10.544366 ] ---------------------------------------------------
[   10.550271 ] *** AA DEADLOCK ***
[   10.550271 ] 
[   10.554875 ] context A
[   10.557136 ]     [S] (unknown)(&larval->completion:0)
[   10.562087 ]     [W] wait_for_completion_killable(&larval->completion:0)
[   10.568688 ]     [E] complete_all(&larval->completion:0)
[   10.573898 ] 
[   10.575377 ] [S]: start of the event context
[   10.579546 ] [W]: the wait blocked
[   10.582848 ] [E]: the event not reachable
[   10.586757 ] ---------------------------------------------------
[   10.592662 ] context A's detail
[   10.595703 ] ---------------------------------------------------
[   10.601608 ] context A
[   10.603868 ]     [S] (unknown)(&larval->completion:0)
[   10.608819 ]     [W] wait_for_completion_killable(&larval->completion:0)
[   10.615419 ]     [E] complete_all(&larval->completion:0)
[   10.620630 ] 
[   10.622109 ] [S] (unknown)(&larval->completion:0):
[   10.626799 ] (N/A)
[   10.628712 ] 
[   10.630191 ] [W] wait_for_completion_killable(&larval->completion:0):
[   10.636537 ] [<ffffffc0104dfc20>] crypto_wait_for_test+0x40/0x80
[   10.642443 ] stacktrace:
[   10.644881 ]       wait_for_completion_killable+0x34/0x160
[   10.650267 ]       crypto_wait_for_test+0x40/0x80
[   10.654871 ]       crypto_register_instance+0xb0/0xe0
[   10.659824 ]       akcipher_register_instance+0x30/0x38
[   10.664950 ]       pkcs1pad_create+0x238/0x2b0
[   10.669295 ]       cryptomgr_probe+0x40/0xd0
[   10.673467 ]       kthread+0x150/0x188
[   10.677118 ]       ret_from_fork+0x10/0x18
[   10.681114 ] 
[   10.682592 ] [E] complete_all(&larval->completion:0):
[   10.687544 ] [<ffffffc0104e8d20>] cryptomgr_probe+0xb0/0xd0
[   10.693016 ] stacktrace:
[   10.695452 ]       complete_all+0x30/0x70
[   10.699362 ]       cryptomgr_probe+0xb0/0xd0
[   10.703532 ]       kthread+0x150/0x188
[   10.707181 ]       ret_from_fork+0x10/0x18
[   10.711177 ] ---------------------------------------------------
[   10.717083 ] information that might be helpful
[   10.721426 ] ---------------------------------------------------
[   10.727334 ] CPU: 0 PID: 1787 Comm: cryptomgr_probe Tainted: G        W
5.4.96-242 #1
[   10.735757 ] Hardware name: LG Electronics, DTV SoC LG1213 (AArch64) (DT)
[   10.742444 ] Call trace:
[   10.744879 ]  dump_backtrace+0x0/0x148
[   10.748529 ]  show_stack+0x14/0x20
[   10.751833 ]  dump_stack+0xd0/0x12c
[   10.755223 ]  print_circle+0x3b0/0x3f8
[   10.758873 ]  cb_check_dl+0x54/0x70
[   10.762262 ]  bfs+0x64/0x1a0
[   10.765043 ]  add_dep+0x90/0xb8
[   10.768086 ]  dept_event+0x4c8/0x560
[   10.771562 ]  complete_all+0x30/0x70
[   10.775038 ]  cryptomgr_probe+0xb0/0xd0
[   10.778774 ]  kthread+0x150/0x188
[   10.781989 ]  ret_from_fork+0x10/0x18
[   10.786091 ] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   10.792783 ] platform regulatory.0: Direct firmware load for
regulatory.db failed with error -2
[   10.796148 ] ALSA device list:
[   10.801423 ] cfg80211: failed to load regulatory.db


