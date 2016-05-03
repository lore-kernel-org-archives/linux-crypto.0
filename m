From: Alexandru Ardelean <Alexandru.Ardelean@riverbed.com>
Subject: RE: [PATCH] crypto: talitos: fix driver init
Date: Tue, 3 May 2016 08:10:37 +0000
Message-ID: <0F8F66EC4F33D04395F7D1131D441FD9DF0F2D@sfo1exc-mbxp08.nbttech.com>
References: <1461852930-714-1-git-send-email-aardelean@riverbed.com>,<6a016fc9-b023-4d04-b163-998d6a85a8eb@GB-CAM-EXCAS1.Emea.Arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Kim Phillips <kim.phillips@arm.com>,
	Alexandru Ardelean <ardeleanalex@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eng.riverbed.com ([208.70.196.45]:21225 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbcECIUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 04:20:17 -0400
In-Reply-To: <6a016fc9-b023-4d04-b163-998d6a85a8eb@GB-CAM-EXCAS1.Emea.Arm.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I was notified by a fellow member of the OpenWrt list that the talitos was already fixed in the crypto-dev repo so I backported that patch into our tree.

He also pointed out (gracefully) that I was a bit naive with regard to the fact that just setting the statesize is not enough.

Sorry for the noise.

Thanks
Alex

________________________________________
From: Kim Phillips [kim.phillips@arm.com]
Sent: Saturday, April 30, 2016 1:55 AM
To: Alexandru Ardelean
Cc: linux-crypto@vger.kernel.org; Alexandru Ardelean
Subject: Re: [PATCH] crypto: talitos: fix driver init

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
