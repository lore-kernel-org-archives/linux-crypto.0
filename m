From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 1/4] crypto: ccp - Remove check for x86 family and model
Date: Thu, 3 Mar 2016 08:26:48 -0600
Message-ID: <56D849A8.6040701@amd.com>
References: <20160301194831.6788.2154.stgit@taos.amd.com>
 <20160301194854.6788.20633.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0089.outbound.protection.outlook.com ([207.46.100.89]:39808
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756234AbcCCOmC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Mar 2016 09:42:02 -0500
In-Reply-To: <20160301194854.6788.20633.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/01/2016 01:48 PM, Gary R Hook wrote:
> Each x86 SoC will make use of a unique PCI ID for the CCP
> device so it is not necessary to check for the CPU family
> and model.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/ccp-dev.c |   47 ++++++++++--------------------------------
>  1 file changed, 11 insertions(+), 36 deletions(-)
