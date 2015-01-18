From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: Intel GCM: __driver-gcm-aes-aesni setkey missing
Date: Sat, 17 Jan 2015 17:37:06 -0800
Message-ID: <54BB0E42.9070209@intel.com>
References: <1976848.LqsUs5V3zD@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>, aidan.o.mahony@intel.com,
	gabriele.paoloni@intel.com, adrian.hoban@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:52615 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbbARBka (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Jan 2015 20:40:30 -0500
In-Reply-To: <1976848.LqsUs5V3zD@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 01/17/2015 10:23 AM, Stephan Mueller wrote:
> during testing of my algif_aead patch with the different GCM implementations I 
> am able to trigger a kernel crash from user space using __driver-gcm-aes-
> aesni.
> 
> As I hope that algif_aead is going to be included, unprivileged userspace 
> would then reliably crash the kernel -- with the current kernel code, 
> userspace has no interface to trigger the issue.

Yes, that's a problem.

> 
> As I am not sure what the purpose of __driver-gcm-aes-aesni is (only a backend 
> for RFC4106 GCM or a regular cipher), I did not yet create a patch. IMHO there 
> are two solutions:
> 
> - either create a valid setkey callback so that a key is set
> 
> - or create a noop setkey that returns -EOPNOTSUPP which effectively disables 
> that cipher for regular consumption.

__driver-gcm-aes-aesni is only a helper for rfc4106-gcm-aesni and it
never supposed to be used on it's own. I think implementing a setkey
function that only returns an error would be a good solution for this.
Another question is what if someone will ignore the error or skip the
setsockopt(ALG_SET_KEY) altogether and still call the sendmsg() and
read() to trigger encrypt()?

> Note, if it is only a backend for the RFC4106 implementation, may I ask why 
> __driver-gcm-aes-aesni is implemented as a separate cipher that is registered 
> with the kernel crypto API?

This is because we need to have one instance of the helper tfm with its
context per each of the rfc4106-gcm-aesni tfm instance and that was one
convenient way to do this.

Tadeusz
