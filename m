Return-Path: <SRS0=b5bf=R7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF16CC10F03
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 05:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9AAB2173C
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 05:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfC1FkE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Mar 2019 01:40:04 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:53720 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfC1FkE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Mar 2019 01:40:04 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h9Nlb-0003VL-Bs; Thu, 28 Mar 2019 13:39:55 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h9NlQ-0005x1-Fw; Thu, 28 Mar 2019 13:39:44 +0800
Date:   Thu, 28 Mar 2019 13:39:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     linux-crypto@vger.kernel.org, atul.gupta@chelsio.com,
        pabeni@redhat.com, eric.dumazet@gmail.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] crypto: chtls - handle inet_csk_reqsk_queue_add()
 failures
Message-ID: <20190328053944.ye5rztc2n7r4tot4@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c96b622f873160880843766d62f4ccac08abd302.1553208186.git.gnault@redhat.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Guillaume Nault <gnault@redhat.com> wrote:
> While working on 9d3e1368bb45 ("tcp: handle inet_csk_reqsk_queue_add()
> failures"), I missed this usage of inet_csk_reqsk_queue_add().
> 
> inet_csk_reqsk_queue_add() can fail. In that case, the operation is
> aborted and inet_csk_destroy_sock() is called automatically, but we
> need to free the request socket manually.
> 
> RFC:
> Sending as RFC because I'm unsure about how to handle 'child' in that
> case. I don't call add_to_reap_list(child) here, because
> inet_csk_destroy_sock() has already run. Therefore, most of the
> operations performed by add_to_reap_list()/process_reap_list() would be
> redundant (but harmless). Except for two things:
> 
>  * process_reap_list() calls inet_csk_destroy_sock() if ->sk_state is
>    TCP_CLOSE. We have to avoid that. Socket's state should be
>    TCP_ESTABLISHED at the time of the call, but process_reap_list() is
>    run asynchronously and I couldn't find anything that would
>    prevent the rest of the system from accessing the socket before
>    process_reap_list() picks it up (the socket is still accessible
>    from cdev->tids). So I fear that calling add_to_reap_list() in the
>    error path would let process_reap_list() call
>    inet_csk_reqsk_queue_add() a second time if ->sk_state was
>    concurrently set to TCP_CLOSE. That looks like a good reason not to
>    call add_to_reap_list().
> 
>  * The only operation that process_reap_list() does and isn't already
>    done by inet_csk_destroy_sock() is chtls_abort_conn(). This
>    function has no effect if its sk_buff allocation fails. So it might
>    be a no-op. That looks like another reason for not calling
>    add_to_reap_list()...
>    But what chtls_abort_conn() does when sk_buff allocation succeeds
>    looks actually important. IIUC, it sends a message to trigger the
>    removal of the socket (how would the socket be removed from ->tids
>    otherwise?). That would make chtls_abort_conn() quite important.
>    But then how do we avoid losing track of those defunct sockets when
>    sk_buff allocation fails?
> 
> Compile-tested only.
> 
> Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
> Reported-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
> drivers/crypto/chelsio/chtls/chtls_cm.c | 13 +++++++++----
> 1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
> index 59b75299fcbc..4bf1e3f65400 100644
> --- a/drivers/crypto/chelsio/chtls/chtls_cm.c
> +++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
> @@ -1384,11 +1384,16 @@ static void add_pass_open_to_parent(struct sock *child, struct sock *lsk,
> 	if (sk_acceptq_is_full(lsk)) {
> 		chtls_reqsk_free(oreq);
> 		add_to_reap_list(child);
> -	} else {
> -		refcount_set(&oreq->rsk_refcnt, 1);
> -		inet_csk_reqsk_queue_add(lsk, oreq, child);
> -		lsk->sk_data_ready(lsk);
> +		return;
> +	}
> +
> +	refcount_set(&oreq->rsk_refcnt, 1);
> +	if (!inet_csk_reqsk_queue_add(lsk, oreq, child)) {
> +		chtls_reqsk_free(oreq);
> +		/* child already dropped by inet_csk_destroy_sock() */
> +		return;
> 	}
> +	lsk->sk_data_ready(lsk);
> }
> 
> static void bl_add_pass_open_to_parent(struct sock *lsk, struct sk_buff *skb)

Dave, Eric, could you guys take a look at this patch please?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
