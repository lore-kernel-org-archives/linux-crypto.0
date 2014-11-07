From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 4/4] crypto: qat - Add new algif interface for userspace
Date: Fri, 07 Nov 2014 11:48:16 -0800
Message-ID: <545D2200.2020107@intel.com>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1> <20141106195953.13328.77022.stgit@tstruk-mobl1> <20141107025607.GA9474@gondor.apana.org.au> <545C3FDB.4010106@intel.com> <20141107040531.GA9865@gondor.apana.org.au> <545C5786.4030205@intel.com> <20141107053105.GA17825@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64420 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbaKGTuz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2014 14:50:55 -0500
In-Reply-To: <20141107053105.GA17825@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
On 11/06/2014 09:31 PM, Herbert Xu wrote:
> On Thu, Nov 06, 2014 at 09:24:22PM -0800, Tadeusz Struk wrote:
>>
>> What about aead? Using my algif_qat I can build a single request to HW
>> that preforms both encryption and authentication in one go, ever for
>> things like aes-cbc-hmac-sha1. This allows me to get great performance
>> of authenticated encryption from user space.
> 
> aead is simpler as it's already part of the API so we just need to
> add algif_aead.
> 
> Cheers,
> 

Another thing is that the algif_skcipher works in kind of synchronous way:

-------             ----------
| app |--write()--> | socket | --> build_sgl()
-------             ----------        |
   <----------------------------------/
-------             ----------                   ------
| app |--read()---> | socket | --send_to_hw()--> | HW |
-------             ----------        |          ------
                                      |            |
                                      |            |
   <-------------------------------wait() <--------/



What I do in the algif_qat is this:

-------             ----------                   ------
| app |--write()--> | socket | --send_to_hw()--> | HW |
-------             ----------        |          ------
   <----------------------------------/            |
                         <-------------------------/
-------             ----------
| app |--read()---> | socket |
-------             ----------
                        |
   <--------------------/

This way I can get much higher throughput than with algif_skcipher.
Regards,
Tadeusz
