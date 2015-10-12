From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 3/8] crypto: ccp: Use precalculated hash from headers
Date: Mon, 12 Oct 2015 16:16:48 -0500
Message-ID: <561C2340.9080909@amd.com>
References: <1444668826-6531-1-git-send-email-clabbe.montjoie@gmail.com>
 <1444668826-6531-4-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
To: LABBE Corentin <clabbe.montjoie@gmail.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<geert+renesas@glider.be>, <ulf.hansson@linaro.org>,
	<wsa@the-dreams.de>, <keescook@chromium.org>,
	<maxime.ripard@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0077.outbound.protection.outlook.com ([207.46.100.77]:51712
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751284AbbJLVRA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2015 17:17:00 -0400
In-Reply-To: <1444668826-6531-4-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/12/2015 11:53 AM, LABBE Corentin wrote:
> Precalculated hash for empty message are now present in hash headers.
> This patch just use them.
>
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Just a minor comment below.

Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/ccp-ops.c | 40 ++++++++--------------------------------
>   1 file changed, 8 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index d09c6c4..3002b418 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -152,32 +152,6 @@ static const __be32 ccp_sha256_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
>   	cpu_to_be32(SHA256_H6), cpu_to_be32(SHA256_H7),
>   };
>
> -/* The CCP cannot perform zero-length sha operations so the caller
> - * is required to buffer data for the final operation.  However, a
> - * sha operation for a message with a total length of zero is valid
> - * so known values are required to supply the result.
> - */
> -static const u8 ccp_sha1_zero[CCP_SHA_CTXSIZE] = {
> -	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
> -	0x32, 0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90,
> -	0xaf, 0xd8, 0x07, 0x09, 0x00, 0x00, 0x00, 0x00,
> -	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> -};
> -
> -static const u8 ccp_sha224_zero[CCP_SHA_CTXSIZE] = {
> -	0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9,
> -	0x47, 0x61, 0x02, 0xbb, 0x28, 0x82, 0x34, 0xc4,
> -	0x15, 0xa2, 0xb0, 0x1f, 0x82, 0x8e, 0xa6, 0x2a,
> -	0xc5, 0xb3, 0xe4, 0x2f, 0x00, 0x00, 0x00, 0x00,
> -};
> -
> -static const u8 ccp_sha256_zero[CCP_SHA_CTXSIZE] = {
> -	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
> -	0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
> -	0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
> -	0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52, 0xb8, 0x55,
> -};
> -
>   static u32 ccp_addr_lo(struct ccp_dma_info *info)
>   {
>   	return lower_32_bits(info->address + info->offset);
> @@ -1388,18 +1362,20 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   		if (sha->msg_bits)
>   			return -EINVAL;
>
> -		/* A sha operation for a message with a total length of zero,
> -		 * return known result.
> -		 */
> +/* The CCP cannot perform zero-length sha operations so the caller
> + * is required to buffer data for the final operation.  However, a
> + * sha operation for a message with a total length of zero is valid
> + * so known values are required to supply the result.
> + */

This comment should be indented and re-flowed to be consistent with
previous comments in this same section.

Thanks,
Tom

>   		switch (sha->type) {
>   		case CCP_SHA_TYPE_1:
> -			sha_zero = ccp_sha1_zero;
> +			sha_zero = sha1_zero_message_hash;
>   			break;
>   		case CCP_SHA_TYPE_224:
> -			sha_zero = ccp_sha224_zero;
> +			sha_zero = sha224_zero_message_hash;
>   			break;
>   		case CCP_SHA_TYPE_256:
> -			sha_zero = ccp_sha256_zero;
> +			sha_zero = sha256_zero_message_hash;
>   			break;
>   		default:
>   			return -EINVAL;
>
