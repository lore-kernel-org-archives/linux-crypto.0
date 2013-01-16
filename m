From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC 0/1] ima/evm: signature verification support using
 asymmetric keys
Date: Wed, 16 Jan 2013 14:45:41 -0500
Message-ID: <1358365541.4593.190.camel@falcor1>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, jmorris@namei.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:60364 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3APTqB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jan 2013 14:46:01 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 16 Jan 2013 12:46:00 -0700
In-Reply-To: <cover.1358246017.git.dmitry.kasatkin@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2013-01-15 at 12:34 +0200, Dmitry Kasatkin wrote:
> Asymmetric keys were introduced in linux-3.7 to verify the signature on signed
> kernel modules.  The asymmetric keys infrastructure abstracts the signature
> verification from the crypto details.  This patch adds IMA/EVM signature
> verification using asymmetric keys.  Support for additional signature
> verification methods can now be delegated to the asymmetric key infrastructure.
> 
> Although the module signature header and the IMA/EVM signature header could
> use the same header format, to minimize the signature length and save space
> in the extended attribute, the IMA/EVM header format is different than the
> module signature header.  The main difference is that the key identifier is
> a sha1[12 - 19] hash of the key modulus and exponent and similar to the current
> implementation. The only purpose is to identify corresponding key in the kernel
> keyring. ima-evm-utils was updated to support the new signature format.

David, are you ok with how support for asymmetric keys is being added to
EVM/IMA-appraisal for verifying signatures?  Any comments?

thanks,

Mimi
