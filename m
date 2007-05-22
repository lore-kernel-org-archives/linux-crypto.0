From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [CRYPTO] [1/1] skeleton for async crypto drivers
Date: Tue, 22 May 2007 17:28:48 +0200
Message-ID: <20070522152848.GC32493@Chamillionaire.breakpoint.cc>
References: <20070522151657.GA32493@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51819 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935630AbXEVP2u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 May 2007 11:28:50 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1HqWI4-0000Jf-DZ
	for linux-crypto@vger.kernel.org; Tue, 22 May 2007 17:28:48 +0200
Content-Disposition: inline
In-Reply-To: <20070522151657.GA32493@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Sebastian Siewior | 2007-05-22 17:16:57 [+0200]:

>+static int async_d_init(struct crypto_tfm *tfm)
>+{
>+	/* important to save request specific data */
>+	tfm->crt_ablkcipher.reqsize = sizeof(struct async_d_request);
>+	return 0;
>+}
..
>+static int process_requests_thread(void *data) {
..
>+				if (backlog) {
>+					ablk_req = ablkcipher_request_cast(backlog);
>+					a_d_backreq = ablkcipher_request_ctx(ablk_req);
>+					a_d_backreq->crypto_complete(backlog, -EINPROGRESS);
>+				}
>+
>+				ablk_req = ablkcipher_request_cast(req);
>+				a_d_ctx = ablkcipher_request_ctx(ablk_req);
>+				a_d_ctx->crypto_complete(req, 0);
>+			}
...

Currently the crypto driver has to allocate a structure in order to
remember later whether encrypt or decrypt is requested. 
Isn't it better to add a operation field into the request struct which
contains the requested operation (set but the crypto user)? This would
then replace encrypt & decrypt function with a crypt function which
queues the request.

Sebastian
