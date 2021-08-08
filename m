Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B79C432BE
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Aug 2021 04:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7180760200
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Aug 2021 04:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbhHHEqQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Aug 2021 00:46:16 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52032 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhHHEqP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Aug 2021 00:46:15 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mCah5-0002dm-28; Sun, 08 Aug 2021 12:45:51 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mCagk-0007tW-Sv; Sun, 08 Aug 2021 12:45:30 +0800
Date:   Sun, 8 Aug 2021 12:45:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Byungchul Park <byungchul.park@lge.com>
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
Message-ID: <20210808044530.GA30313@gondor.apana.org.au>
References: <20210803021611.GA28236@X58A-UD3R>
 <20210806080344.GA5788@X58A-UD3R>
 <20210806114058.GA13896@gondor.apana.org.au>
 <20210807034639.GA8726@X58A-UD3R>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807034639.GA8726@X58A-UD3R>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 07, 2021 at 12:46:39PM +0900, Byungchul Park wrote:
>
> > > THREAD C
> > > --------
> > > C1 cryptomgr_test()
> > > C2    crypto_alg_tested()
> > > C3       complete_all(c)
> > > 
> > > For example, in this situation, I think C3 could wake up both A6 and B9
> > > before THREAD B reaches B10 which is not desired by A6. Say, is it okay
> > > to wake up A6 with B7 ~ B9 having yet to complete?
> > 
> > AFAICS thread C only wakes up test larvals, not instantiation larvals.
> > Please let me know if you have any further issues.
> 
> The both cases looks like to get the larvals from the same list,
> crypto_alg_list, one from crypto_larval_lookup() and the other from
> __crypto_register_alg(). So I thought a single larval can be used at the
> same time both at crypto_wait_for_test() and crypto_alg_mod_lookup() by
> any chance. It would be great if the code ensures it never happens :-)

Perhaps it's not obvious but the distinguishing feature between test
larvals and the other kind of larvals is that test larvals have a
non-null cra_driver_name field.

In crypto_alg_tested we specifically exclude non-test larvals
when doing the lookup.

> The problematic scenario I wanted to ask you looks like - I was
> wondering if it's okay to nest requesting CRYPTO_MSG_ALG_REQUEST and
> CRYPTO_MSG_ALG_REGISTER in a single stack, in other words, if it's okay
> to try CRYPTO_MSG_ALG_REGISTER before completing CRYPTO_MSG_ALG_REQUEST.
> 
> A1 crypto_alg_mod_lookup()
> A2    crypto_probing_notify(CRYPTO_MSG_ALG_REQUEST)
> A3       cryptomgr_schedule_probe()
> A4          kthread_run(cyptomgr_probe) ---> Start THREAD B
> 
> B1 cryptomgr_probe()
> B2    pkcslpad_create()
> B3       crypto_wait_for_test()
> B4          crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER)
> B5             cryptomgr_schedule_test()
> B6                kthread_run(cyptomgr_test) ---> Start THREAD C
> 
> C1 cryptomgr_test()
> C2    crypto_alg_tested()
> C3       complete_all(c) <- *the point* that I'd like to ask you.

Well c in this case can only be a test larval so it cannot wake
up thread A which is waiting on a non-test larval.

> A5    crypto_larval_wait()
> A6       wait_for_completion_killable_timeout(c) /* waiting for B10 */
>          (wake up and go)
> 
> Bx          wait_for_completion_killable(c) /* waiting for C3 */
>             (wake up and go)
> Bx    tmpl->alloc()
> Bx    crupto_register_instance()
> B10   complete_all(c)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
