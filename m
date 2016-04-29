From: Kim Phillips <kim.phillips@arm.com>
Subject: Re: [PATCH] crypto: talitos: fix driver init
Date: Fri, 29 Apr 2016 17:55:22 -0500
Message-ID: <6a016fc9-b023-4d04-b163-998d6a85a8eb@GB-CAM-EXCAS1.Emea.Arm.com>
References: <1461852930-714-1-git-send-email-aardelean@riverbed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>,
	Alexandru Ardelean <aardelean@riverbed.com>
To: Alexandru Ardelean <ardeleanalex@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu-smtp-delivery-143.mimecast.com ([146.101.78.143]:45428 "EHLO
	eu-smtp-delivery-143.mimecast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbcD2Wzq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 18:55:46 -0400
In-Reply-To: <1461852930-714-1-git-send-email-aardelean@riverbed.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 28 Apr 2016 17:15:30 +0300
Alexandru Ardelean <ardeleanalex@gmail.com> wrote:

> From: Alexandru Ardelean <ardeleanalex@gmail.com>
>
> Crypto hash algorithms must provide the statesize sometime
> from kernel 4.2 onwards.
> Since commit 8996eafdcbad149ac0f772fb1649fbb75c482a6a
>
> Signed-off-by: Alexandru Ardelean <aardelean@riverbed.com>
> ---

This should already have been fixed here:

www.spinics.net/lists/linux-crypto/msg19225.html

> @@ -2458,6 +2458,7 @@ static struct talitos_alg_template driver_algs[] = {
>       {       .type = CRYPTO_ALG_TYPE_AHASH,
>               .alg.hash = {
>                       .halg.digestsize = MD5_DIGEST_SIZE,
> +                     .halg.statesize  = sizeof(struct talitos_ahash_req_ctx),

although I'm not sure why these statesize assignments aren't being
done in talitos_alg_alloc() there either

Thanks,

Kim
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
