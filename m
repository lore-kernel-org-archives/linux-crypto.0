From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: Fix ASN.1 key handling for RSA akcipher
Date: Sat, 29 Aug 2015 07:34:15 -0700
Message-ID: <55E1C2E7.2040604@intel.com>
References: <20150829065552.GA18342@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, dhowells@redhat.com,
	dwmw2@infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:48023 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbbH2Ofj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Aug 2015 10:35:39 -0400
In-Reply-To: <20150829065552.GA18342@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/28/2015 11:55 PM, Herbert Xu wrote:
> I think having separate functions for setting public
> and private keys makes sense.

So I'm going to proceed with this approach.
Thanks everyone for your comments.
