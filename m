From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: Re: [PATCH 4/4][RFC] crypto: michael_mic - Switch to shash
Date: Thu, 04 Dec 2008 09:04:38 +0100
Message-ID: <49378F16.9040705@codelabs.ch>
References: <12283498922490-git-send-email-ken@codelabs.ch> <12283498932360-git-send-email-ken@codelabs.ch> <12283498942104-git-send-email-ken@codelabs.ch> <12283498953450-git-send-email-ken@codelabs.ch> <12283498962759-git-send-email-ken@codelabs.ch> <20081204032956.GA16987@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:56882 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYLDIEl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2008 03:04:41 -0500
In-Reply-To: <20081204032956.GA16987@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Thu, Dec 04, 2008 at 01:18:12AM +0100, Adrian-Ken Rueegsegger wrote:
>>  struct michael_mic_ctx {
>> +	u32 l, r;
>> +};
>> +
>> +struct michael_mic_desc_ctx {
>>  	u8 pending[4];
>>  	size_t pending_len;
>>  
>>  	u32 l, r;
>>  };
> 
> Any reason why you left them in the desc context?

As I explained in the other mail, the values l and r are not readonly.
Therefor I believe they need to be copied from the tfm context to the
descriptor upon transformation.

Adrian
