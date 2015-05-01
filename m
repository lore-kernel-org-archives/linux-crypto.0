From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 1/2] crypto: add PKE API
Date: Fri, 01 May 2015 10:30:37 -0700
Message-ID: <5543B83D.1090606@intel.com>
References: <20150430223647.10157.82156.stgit@tstruk-mobl1> <20150430223652.10157.86151.stgit@tstruk-mobl1> <1788430.tPLLCmOF11@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, corbet@lwn.net, keescook@chromium.org,
	qat-linux@intel.com, jwboyer@redhat.com, richard@nod.at,
	linux-kernel@vger.kernel.org, steved@redhat.com,
	dhowells@redhat.com, vgoyal@redhat.com, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9424 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbbEARdo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 May 2015 13:33:44 -0400
In-Reply-To: <1788430.tPLLCmOF11@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 05/01/2015 12:24 AM, Stephan Mueller wrote:
>> +struct public_key;
>> >+struct public_key_signature;
> Wouldn't it make sense to move the struct definitions here and have them 
> documented?

I'm not sure if they belong here. I think we can add some documentation
without moving them.

>> +struct pke_alg {
>> >+	int (*sign)(struct pke_request *pkereq);
>> >+	int (*verify)(struct pke_request *pkereq);
>> >+	int (*encrypt)(struct pke_request *pkereq);
>> >+	int (*decrypt)(struct pke_request *pkereq);
>> >+
>> >+	u8 pub_mpis;	/* Number of MPIs in public key */
>> >+	u8 sec_mpis;	/* Number of MPIs in secret key */
>> >+	u8 sig_mpis;	/* Number of MPIs in a signature */
> May I ask that for such new structs we add some documentation? Currently, I am 
> unclear on what MPIs are. E.g. if somebody needs to add, say, Curve 25519, 
> what shall he add here?

Sure, I'll add some description.

> 
> Up to here I am volunteering to add the documentation comments.
> 
> But for the following functions, I am not sure how they are supposed to be 
> used correctly. Thus, can you add the documentation for them or at least give 
> me a hint so that I can add the documentation?

Same here, I'll add something. Thanks for volunteering.
You did a good job documenting the rest and your help will be appreciated.
