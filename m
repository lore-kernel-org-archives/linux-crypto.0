Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E852C4338F
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 03:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55913610CB
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 03:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhHGDrj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 23:47:39 -0400
Received: from lgeamrelo13.lge.com ([156.147.23.53]:35508 "EHLO
        lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230398AbhHGDri (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 23:47:38 -0400
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
        by 156.147.23.53 with ESMTP; 7 Aug 2021 12:47:19 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: byungchul.park@lge.com
Received: from unknown (HELO X58A-UD3R) (10.177.222.33)
        by 156.147.1.121 with ESMTP; 7 Aug 2021 12:47:19 +0900
X-Original-SENDERIP: 10.177.222.33
X-Original-MAILFROM: byungchul.park@lge.com
Date:   Sat, 7 Aug 2021 12:46:39 +0900
From:   Byungchul Park <byungchul.park@lge.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     torvalds@linux-foundation.org, peterz@infradead.org,
        mingo@redhat.com, will@kernel.org, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rostedt@goodmis.org, joel@joelfernandes.org,
        alexander.levin@microsoft.com, daniel.vetter@ffwll.ch,
        chris@chris-wilson.co.uk, duyuyang@gmail.com,
        johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
        willy@infradead.org, david@fromorbit.com, amir73il@gmail.com,
        bfields@fieldses.org, gregkh@linuxfoundation.org,
        kernel-team@lge.com
Subject: Re: [REPORT] Request for reviewing crypto code wrt
 wait_for_completion()
Message-ID: <20210807034639.GA8726@X58A-UD3R>
References: <20210803021611.GA28236@X58A-UD3R>
 <20210806080344.GA5788@X58A-UD3R>
 <20210806114058.GA13896@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806114058.GA13896@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 06, 2021 at 07:40:58PM +0800, Herbert Xu wrote:
> On Fri, Aug 06, 2021 at 05:03:44PM +0900, Byungchul Park wrote:
> > Hello crypto folks,
> > 
> > I developed a tool for tracking waiters and reporting if any of the
> > events that the waiters are waiting for would never happen, say, a
> > deadlock. Yes, it would look like Lockdep but more inclusive.
> > 
> > While I ran the tool(Dept: Dependency Tracker) on v5.4.96, I got some
> > reports from the tool. One of them is related to crypto subsystem.
> > Because I'm not that familiar with the code, I'd like to ask you guys to
> > review the related code.
> > 
> > If I understand correctly, it doesn't actually cause deadlock but looks
> > like a problematic code. I know you are not used to the format of the
> > report from Dept so.. let me summerize the result.
> > 
> > The simplified call trace looks like when the problem araised :
> > 
> > THREAD A
> > --------
> > A1 crypto_alg_mod_lookup()
> > A2    crypto_probing_notify(CRYPTO_MSG_ALG_REQUEST)
> > A3       cryptomgr_schedule_probe()
> > A4          kthread_run(cyptomgr_probe) ---> Start THREAD B
> > 
> > A5    crypto_larval_wait()
> > A6       wait_for_completion_killable_timeout(c) /* waiting for B10 */
> 
> This larval would be an instantiation larval, and it can only be
> woken up by thread B, not C.

Yes. This is what I understood based on the code.

> > THREAD B
> > --------
> > B1 cryptomgr_probe()
> > B2    pkcslpad_create()
> > B3       crypto_wait_for_test()
> > B4          crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER)
> > B5             cryptomgr_schedule_test()
> > B6                kthread_run(cyptomgr_test) ---> Start THREAD C
> > 
> > B7    tmpl->alloc()
> > B8    crupto_register_instance()
> > B9          wait_for_completion_killable(c) /* waiting for C3 */
> > B10   complete_all(c)
> 
> I presume you're talking about about the wait_for_completion from

Right. Sorry for confusing you.

> crypto_wait_for_test, in which case it can only be woken by thread
> C.  After which thread B will return to cryptomgr_probe and wake up
> thread A.

Yes. This is what I understood based on the code too.

> 
> > THREAD C
> > --------
> > C1 cryptomgr_test()
> > C2    crypto_alg_tested()
> > C3       complete_all(c)
> > 
> > ---
> > 
> > For example, in this situation, I think C3 could wake up both A6 and B9
> > before THREAD B reaches B10 which is not desired by A6. Say, is it okay
> > to wake up A6 with B7 ~ B9 having yet to complete?
> 
> AFAICS thread C only wakes up test larvals, not instantiation larvals.
> Please let me know if you have any further issues.

The both cases looks like to get the larvals from the same list,
crypto_alg_list, one from crypto_larval_lookup() and the other from
__crypto_register_alg(). So I thought a single larval can be used at the
same time both at crypto_wait_for_test() and crypto_alg_mod_lookup() by
any chance. It would be great if the code ensures it never happens :-)

The problematic scenario I wanted to ask you looks like - I was
wondering if it's okay to nest requesting CRYPTO_MSG_ALG_REQUEST and
CRYPTO_MSG_ALG_REGISTER in a single stack, in other words, if it's okay
to try CRYPTO_MSG_ALG_REGISTER before completing CRYPTO_MSG_ALG_REQUEST.

A1 crypto_alg_mod_lookup()
A2    crypto_probing_notify(CRYPTO_MSG_ALG_REQUEST)
A3       cryptomgr_schedule_probe()
A4          kthread_run(cyptomgr_probe) ---> Start THREAD B

B1 cryptomgr_probe()
B2    pkcslpad_create()
B3       crypto_wait_for_test()
B4          crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER)
B5             cryptomgr_schedule_test()
B6                kthread_run(cyptomgr_test) ---> Start THREAD C

C1 cryptomgr_test()
C2    crypto_alg_tested()
C3       complete_all(c) <- *the point* that I'd like to ask you.

A5    crypto_larval_wait()
A6       wait_for_completion_killable_timeout(c) /* waiting for B10 */
         (wake up and go)

Bx          wait_for_completion_killable(c) /* waiting for C3 */
            (wake up and go)
Bx    tmpl->alloc()
Bx    crupto_register_instance()
B10   complete_all(c)

I think I've shown you all the detail about the problematic flow. If
it still looks okay to you, then it'd be great!

Thank you,
Byungchul

> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
