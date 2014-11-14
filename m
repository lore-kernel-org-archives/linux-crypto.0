From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 4/4] crypto: qat - Add new algif interface for userspace
Date: Thu, 13 Nov 2014 17:25:29 -0800
Message-ID: <54655A09.9000800@intel.com>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1> <20141106195953.13328.77022.stgit@tstruk-mobl1> <20141107025607.GA9474@gondor.apana.org.au> <545C3FDB.4010106@intel.com> <20141107040531.GA9865@gondor.apana.org.au> <545C5786.4030205@intel.com> <20141107053105.GA17825@gondor.apana.org.au> <545D2200.2020107@intel.com> <20141114011911.GA10647@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64066 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933754AbaKNB2Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Nov 2014 20:28:25 -0500
In-Reply-To: <20141114011911.GA10647@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 11/13/2014 05:19 PM, Herbert Xu wrote:
>> > This way I can get much higher throughput than with algif_skcipher.
> Yes that's a worthy optimisation.  See if you can change the
> current implementation (without changing the interface) to achieve
> this.
Ok, I'll have a look. What about the asymmetric algorithms?
Regards,
Tadeusz
