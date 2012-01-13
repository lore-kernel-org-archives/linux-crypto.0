From: Varun Wadekar <vwadekar@nvidia.com>
Subject: Re: [PATCH v8 0/2] crypto: driver for Tegra AES hardware
Date: Fri, 13 Jan 2012 11:07:42 +0530
Message-ID: <4F0FC326.7080307@nvidia.com>
References: <1324034755-3295-1-git-send-email-vwadekar@nvidia.com> <20120113053557.GA13918@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14485 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2AMFhq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Jan 2012 00:37:46 -0500
In-Reply-To: <20120113053557.GA13918@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday 13 January 2012 11:05 AM, Herbert Xu wrote:
> On Fri, Dec 16, 2011 at 11:25:53AM +0000, Varun Wadekar wrote:
>> The tegra crypto driver uses the tegra_chip_uid API for the RNG
>> calculation. If one wants to build tegra-aes as a module, then
>> tegra_chip_uid needs to be exported.
> Both patches applied.  Thanks!

Thanks Herbert.
