From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: Fix ccp_run_passthru_cmd dma variable assignments
Date: Fri, 24 Jan 2014 14:17:12 -0600
Message-ID: <52E2CA48.4070500@amd.com>
References: <20140124183934.GA3423@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:27709
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaAXURU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jan 2014 15:17:20 -0500
In-Reply-To: <20140124183934.GA3423@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/24/2014 12:39 PM, Dave Jones wrote:
> There are some suspicious looking lines of code in the new ccp driver, including
> one that assigns a variable to itself, and another that overwrites a previous assignment.
> 
> This may have been a cut-and-paste error where 'src' was forgotten to be changed to 'dst'.
> I have no hardware to test this, so this is untested.

Yes, this was a cut-and-paste error that was not discovered with my tests. I've
updated my testcases and tested/verified this fix.

Herbert, this should probably go through the cryptodev-2.6 tree right?

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks,
Tom

> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 71ed3ade7e12..c266a7b154bb 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1666,8 +1666,8 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
>   
>   		op.dst.type = CCP_MEMTYPE_SYSTEM;
>   		op.dst.u.dma.address = sg_dma_address(dst.sg_wa.sg);
> -		op.src.u.dma.offset = dst.sg_wa.sg_used;
> -		op.src.u.dma.length = op.src.u.dma.length;
> +		op.dst.u.dma.offset = dst.sg_wa.sg_used;
> +		op.dst.u.dma.length = op.src.u.dma.length;
>   
>   		ret = ccp_perform_passthru(&op);
>   		if (ret) {
> 
