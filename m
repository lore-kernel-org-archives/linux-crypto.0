From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: Limited usefulness of RSA set key function
Date: Mon, 03 Aug 2015 10:11:17 -0700
Message-ID: <55BFA0B5.6070107@intel.com>
References: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org> <3848823.PNN01JLIZu@tauon.atsec.com> <6876D9AA-A51A-4D79-9127-3B3ED58784CA@holtmann.org> <1580424.u6GEQiXd8T@myon.chronox.de> <2726A091-A7A2-451F-BB11-A19A73DA3C36@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64122 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbbHCRMH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 13:12:07 -0400
In-Reply-To: <2726A091-A7A2-451F-BB11-A19A73DA3C36@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Marcel,
On 08/03/2015 12:30 AM, Marcel Holtmann wrote:
> as you can clearly see. There are two formats defined here. There is no single ASN.1 structure that can decode both of these.
> 
> It is what it is, RSA Public Key and RSA Private Key formats are two different key formats. And OpenSSL also treats it like this. You can extract the public key from a private key (same way you can extract it from a certificate), but you can not create a private key structure that only contains the public key.
> 
> For RSA we need to support the two formats as listed above. To make this really easy from an API point of view, I would have setkey and setpubkey function. And also expose them as ALG_SET_KEY and ALG_SET_PUBKEY socket options for AF_ALG.

I'll have a look what will be the easiest way to get the openSSL generated & unmodified private key working.
Thanks,
T
