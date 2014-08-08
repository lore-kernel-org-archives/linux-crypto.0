From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: testmgr.c: white space fix-ups on test_aead
Date: Fri, 8 Aug 2014 12:22:44 +0300
Message-ID: <53E496E4.9070207@freescale.com>
References: <1406542283-11995-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1406542283-11995-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/28/2014 1:11 PM, Cristian Stoica wrote:
> This patch inverts two if conditions and allows removal of one
> tab-stop in their code-blocks. Only white-space clean-up follows.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---
>  crypto/testmgr.c | 498 +++++++++++++++++++++++++++----------------------------
>  1 file changed, 242 insertions(+), 256 deletions(-)

This increases readability and reduces number of lines, not to mention
cyclomatic complexity.

While here, could you do this also for other places, like __test_hash?

Thanks,
Horia
