Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703443D1CC5;
	Sat,  3 Oct 2026 09:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791019729; cv=none; b=cIAtuIqkizg96OG484zo9OiIZT7QCdwIUqVE7nmwzE3Ev56wYJgyARxPUpXZXtrMn7IG1L2bd9Fihxme7dGuuXQzVoHwHBjLIxY1P7m4RdvZRJ8UWA4iCDXJfh8J97QYMGGLy8yBp5kzjcszdHyoOJOy2NYOTZTYkIYny10kAz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791019729; c=relaxed/simple;
	bh=Sfk0UwJ3tjklr8atozqCktFvsFL6wQOpuL9pPk57400=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=LPDgDDqYkO4WTDV59jTv5BzX+yArD5UyXm9Ja+CKnpUt4LnDtCJakz7aLJH9gC4EMSv6+RaCH567a1giKkvisA3fveGyhBwG95Bo7PvBeFWNJLcLNbd88zQZMflhSf5TPM+gEAIJBg3nE/NT3fmCeAdA6H405tQsHfICs2gzHoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkOxg/6N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkOxg/6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F341A1F0089D;
	Sat,  3 Oct 2026 09:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791019724;
	bh=NXHTDGFzDR1i3PJvTQnsk21+Bd0QI0atro2c8qzup6Q=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=PkOxg/6NOkWaRJw2lRcg3Q3ZHZoZ7UvNTmcJH5PBroF2UGaXihmHiIkDBFth/zFc4
	 AfWAbn5LzCjCKkRktxiRt0q8zG2NLNAVGwe6FFCyiucxm2YBB/cVCECuv8Fyo0fgNx
	 hEKpOhATEsk1o6iHodM2phuPASx3KfpytVgyuUqvMHmHbrRkLosSU1W6dEtP3l2tnf
	 jfSX26fYLqEGGE8NMewzp7PCr6+OtB64OSs5XGDOQICulsqDTmafvktiWs6kLQNuKv
	 TxxEpLrZ8ZmshAN3vEUZ4Re38MSGuMcH9acVY2fK0Yxu960jOEa81wmvpvo2ehXPnu
	 fpqK168GpF/qg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6DEE7198004A;
	Sat,  3 Oct 2026 05:28:42 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sat, 03 Oct 2026 05:28:42 -0400
X-ME-Sender: <xms:yMrAasEWUgbAGNUnYxj71TZKPvauiJg--gU5wwlOpsCEdfGoEZukcQ>
    <xme:yMrAagLq36RChLbnXxyrr5Lm2zvSXqewGD9DIMC3gws6zL6EVwivnT_FjrMK2oYdo
    t5ZwQC5STeQ9MTOZmpsT9IBJj3tS2dUtJFQIHx-6THwm9aB4wRBzJtU>
X-ME-Proxy-Cause: dmFkZTGUOpTrvF/UVMRbKIW2rMITUrWTIbqE0HIdGbdFFk0eqaRrYo3fXpLhvBwMPblllr
    n+5t7M7F/mcPFRv+mJPQN6MX3tnaCJmh7UHJlLPRzTbb/HrruLCqYzOdGsI03JyJIWT4jC
    3aFkCv5KSpy5ClJ8cP8t8HsARwOyLXQP+BDpE0REpoDWqq4vm17F2CNU+Rf4E6i63Rqdc7
    oZ/gUa6I22JuWZU6U0ZGnGrozSpkCRcSwlbHwR3Yr/5UYAjBT4lM7yeR0IMAB29k/txrn2
    p7f7PzSEQIkcEI5IesFSZRRvdoIx5I5psCZ14IwyBlCz7lUbfOFZWOyO66mc+1EwlTwrlW
    ZnZ8Hc2LE3aIEp3TqRjLFBGhs/iQNYE7PSJnzrmpe0/3Oo9UvTIv4VtNVdR6BAOo+zh2s9
    nFu3NlXbodGxglR7L25Cqd8RdKNpfbNr65VCxx8GFCf/JWTNlTlsS1sY6BpnDs3dqgOoq9
    3SNTs6o18Hu9FSq65irCzkU6yNetbmE70BFzk8FEDhHiv1TjI+TGpNwlmLR1JqPJ9UsdDm
    NMzZsGwtDW+DkbWpwYLY4p9E+ePlTA49RT0rC544jXRRwiBy2CDSs+UCsKndOh0lrMVFN2
    bGLt1DmutxIHejDjX3MWr/4pptCv2d3p7XLzQFBGANNVbha1ofE0VcjmnWMg
X-ME-Proxy: <xmx:ysrAahHHeyhdJNPggX2rvzAVMwfVK6-uG9ZAPk_WUhjkFaWi50tW6A>
    <xmx:ysrAai7vBCtwJ4YeZUDD_ExaJEajK8xOqB0tiY2hmnrsDJ6fXW2ccQ>
    <xmx:ysrAanljC5bWOfb8A2uGOZ1uwMA9QuLdzlGkqnKgainhFvbgvkPLJw>
    <xmx:ysrAat4ROfAveEARUjjhyKqfCb3-HyyW350bp4sp8PVz6MYC6X24Ag>
    <xmx:ysrAaoTnH-eo-2UQQAe6H0H_HL00kb9wsQRGBNAZo2WxbCYzMIc5E6pI>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2139EF8008E; Sat,  3 Oct 2026 05:28:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 03 Oct 2026 11:28:20 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: "Mohamad Raizudeen" <raizudeen.kerneldev@gmail.com>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Shuah Khan" <skhan@linuxfoundation.org>, me@brighamcampbell.com,
 jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-Id: <ea68191f-86cf-44b1-a045-237b93a4953f@app.fastmail.com>
In-Reply-To: <20261003085757.GA144870@quark>
References: <20261003060826.7792-1-raizudeen.kerneldev@gmail.com>
 <b937fca8-f436-47a5-988c-963fa1af6296@app.fastmail.com>
 <20261003085757.GA144870@quark>
Subject: Re: [PATCH] crypto: chacha20poly1305 - Fix missing state zeroization in
 xchacha decrypt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 3 Oct 2026, at 10:57, Eric Biggers wrote:
> On Sat, Oct 03, 2026 at 09:34:21AM +0200, Ard Biesheuvel wrote:
>> 
>> 
>> On Sat, 3 Oct 2026, at 08:08, Mohamad Raizudeen wrote:
>> > The `__chacha20poly1305_decrypt` function does not zeroize the chacha
>> > state, unlike its encrypt counterpart. The regular
>> > `chacha20poly1305_decrypt` function handles this by manually calling
>> > chacha_zeroize_state(). However, `xchacha20poly1305_decrypt` returns
>> > the result directly without clearing the state.
>> >
>> > This leaves the derived chacha20 subkey on the stack after the function
>> > returns. Fix this by storing the return value, calling
>> > chacha_zeroize_state() and then returning the result, matching the
>> > logic in `chacha20poly1305_decrypt`.
>> >
>> > Fixes: ed20078b7e333 ("crypto: chacha20poly1305 - import construction 
>> > and selftest from Zinc")
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
>> > ---
>> >  lib/crypto/chacha20poly1305.c | 5 ++++-
>> >  1 file changed, 4 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/lib/crypto/chacha20poly1305.c 
>> > b/lib/crypto/chacha20poly1305.c
>> > index ea42a28f4ff7..03b14d272520 100644
>> > --- a/lib/crypto/chacha20poly1305.c
>> > +++ b/lib/crypto/chacha20poly1305.c
>> > @@ -199,10 +199,13 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 
>> > *src, const size_t src_len,
>> >  			       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
>> >  {
>> >  	struct chacha_state chacha_state;
>> > +	bool ret;
>> > 
>> >  	xchacha_init(&chacha_state, key, nonce);
>> > -	return __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
>> > +	ret = __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
>> >  					  &chacha_state);
>> > +	chacha_zeroize_state(&chacha_state);
>> > +	return ret;
>> >  }
>> >  EXPORT_SYMBOL(xchacha20poly1305_decrypt);
>> > 
>> 
>> Wouldn't it be better to move the existing call from chacha20poly1305_decrypt()
>> to __chacha20poly1305_decrypt()?
>
> Since __chacha20poly1305_decrypt() has two return statements that would
> need to be considered, I think this patch (which makes each
> *chacha_init() clearly paired with chacha_zeroize_state()) is slightly
> cleaner.
>

Fair enough.
