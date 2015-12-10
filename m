From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] crypto: KEYS: convert public key to akcipher api
Date: Thu, 10 Dec 2015 14:37:05 -0500
Message-ID: <1449776225.4183.1.camel@linux.vnet.ibm.com>
References: <20151209235226.11783.57073.stgit@tstruk-mobl1>
	 <1449771957.2694.2.camel@linux.vnet.ibm.com> <5669C6E4.8030002@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, dhowells@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49333 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbbLJTiD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Dec 2015 14:38:03 -0500
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Fri, 11 Dec 2015 05:37:59 +1000
In-Reply-To: <5669C6E4.8030002@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2015-12-10 at 10:39 -0800, Tadeusz Struk wrote:
> Hi Mimi,
> On 12/10/2015 10:25 AM, Mimi Zohar wrote:
> >> This patch set converts the module verification and digital signature
> >> > code to the new akcipher API.
> >> > RSA implementation has been removed from crypto/asymmetric_keys and the
> >> > new API is used for cryptographic primitives.
> >> > There is no need for MPI above the akcipher API anymore.
> >> > Modules can be verified with software as well as HW RSA implementations.
> > With these two patches my system doesn't even boot.  Digging deeper...
> > 
> 
> It needs RSA implementation built-in.
> Could you check if you have CONFIG_CRYPTO_RSA=y

The diff between this config and the previous one:
< CONFIG_CRYPTO_AKCIPHER=y
< CONFIG_CRYPTO_RSA=y
---
> # CONFIG_CRYPTO_RSA is not set

Mimi
