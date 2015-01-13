From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat - Fix for qat_aes_cbc_hmac_sha512
Date: Tue, 13 Jan 2015 14:21:58 -0800
Message-ID: <54B59A86.10803@intel.com>
References: <20150113202753.32216.26250.stgit@tstruk-mobl1> <20150113212515.GA11562@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:5411 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbbAMWZT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 17:25:19 -0500
In-Reply-To: <20150113212515.GA11562@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 01/13/2015 01:25 PM, Herbert Xu wrote:
>>  		memcpy(ipad, buff, digest_size);
>> >  		memcpy(opad, buff, digest_size);
>> > +		memset(ipad + digest_size, 0, block_size - digest_size);
>> > +		memset(opad + digest_size, 0, block_size - digest_size);
>> >  		memzero_explicit(buff, sizeof(buff));
> The very first thing we do in that function is zero the whole
> auth_state.  So why would we need to zero it here? The only thin
> I can think of is if auth_state is too small and we're encountering
> garbage on the stack which would be a serious bug.

Yes, it looks strange, but the issue is we don't really zero the whole
auth_state. Because struct qat_auth_state is no packed on my system

sizeof(MAX_AUTH_STATE_SIZE + 64) = 244

and sizeof(struct qat_auth_state) = 256

if instead of:

memzero_explicit(auth_state.data, MAX_AUTH_STATE_SIZE + 64);

it would be:

memzero_explicit(&auth_state, sizeof(auth_state));

then it would work as well.
I can send another patch that does the second if you like.
Thanks,
Tadeusz
