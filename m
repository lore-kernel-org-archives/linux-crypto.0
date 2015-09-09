From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/8] lib/scatterlist: Add sg_len helper
Date: Wed, 09 Sep 2015 18:54:29 +0200
Message-ID: <60076735.54FkO3TlLd@tauon.atsec.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1> <2806088.jJiH2yOvUX@tauon.atsec.com> <55F05EC4.5080408@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33834 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbbIIQyf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:54:35 -0400
In-Reply-To: <55F05EC4.5080408@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 9. September 2015, 09:31:00 schrieb Tadeusz Struk:

Hi Tadeusz,

>On 09/09/2015 09:27 AM, Stephan Mueller wrote:
>>> +int sg_len(struct scatterlist *sg)
>> 
>> unsigned int?
>
>No, because it can return -EINVAL if you call it before you set the key.

Just re-reading the code: where would the -EINVAL be generated?

Ciao
Stephan
