Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B89886353;
	Tue,  1 Apr 2025 10:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743505057; cv=none; b=ZmUDJxjw4MVlbDqqbSMiQ6EHP5EfX6WCKbJWjCkVD7QKwJrahd3wyblqKrd+v33V5s2F9/G8WawpKRXw2Be5Jp7igDm5CPSSO7KHhH8hDj1Z9/glILfKQn3s8YXrB2ucxIRSHw5QQ+nnZ43AwxyrKqe4kjelAgu8+sH5gYUUYKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743505057; c=relaxed/simple;
	bh=SecnRZFRRQC2/Ozp9Uh8MS6sUsiH4jCJn7+0iksUvQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ceS0UuaXNAeq8qOZRvlSfBCoieYnKt3Y6uA399kx5SQJrxAbZcmTZJOw8g3XZr0sXJ6iFxyMn9qo3/EFOO+qGGqiNSUWJH/07dHAVJkwKctveMbmKJaZWIbRTe8LlVVHUgF1LxB81i4H+srylinzEdT8/OoPWfRwV/PZKUx8yoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MqAO4Jko; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MqAO4Jko"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5blPN3EyiFVGaeUlfhhjrt6P8PW2cWHwVxZ8k4jGYIk=; b=MqAO4Jko7jOiTECL4fruu0a00E
	qNQYobHztdg0HojoolLoangJs7zj9lLfeGvnaew+1pXo07uBL2UgTeE2bSQkGsMtAeuHfux2MKoVN
	2p9dqe8oC0D32jVP8c2IPPmvRIQQqCiQxCYhTTNaUPxx/xeRu2WQSFDW7Hdx68DTuYzg2UsB1ydNI
	rz0m81bIw2PfpDBG5ffSBf2nHSJSTWlbWIEfl6y2bhEvKTO+MRRvVb+h4LmW6yDQL7Mw66rsdiB2v
	znjDw03Q0Ot8xJuYjobQ4bGXRvJzIHopSbPt7tTWF7Sddsvs5N8CT0teh3Lmni4H6APq0fN6JFBiu
	Qsi0+Dpw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzZJ4-00BoQ2-00;
	Tue, 01 Apr 2025 18:57:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 18:57:21 +0800
Date: Tue, 1 Apr 2025 18:57:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Christian Marangi (Ansuel)" <ansuelsmth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v11 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z-vGkbmX2PQ_gt7Z@gondor.apana.org.au>
References: <20250114123935.18346-1-ansuelsmth@gmail.com>
 <20250114123935.18346-4-ansuelsmth@gmail.com>
 <Z-u67D7xl2_SR-hg@gondor.apana.org.au>
 <CA+_ehUzZruhT7Bko2Xm2kyOaZxUPA4vNLQhq_5V30gfjgmfcng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+_ehUzZruhT7Bko2Xm2kyOaZxUPA4vNLQhq_5V30gfjgmfcng@mail.gmail.com>

On Tue, Apr 01, 2025 at 12:54:05PM +0200, Christian Marangi (Ansuel) wrote:
> Il giorno mar 1 apr 2025 alle ore 12:08 Herbert Xu
> <herbert@gondor.apana.org.au> ha scritto:
> >
> > On Tue, Jan 14, 2025 at 01:36:36PM +0100, Christian Marangi wrote:
> > >
> > > +static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
> > > +                            dma_addr_t *data_dma, u32 len, bool last)
> > > +{
> >
> > ...
> >
> > > +again:
> > > +     ret = eip93_put_descriptor(eip93, &cdesc);
> > > +     if (ret) {
> > > +             usleep_range(EIP93_RING_BUSY_DELAY,
> > > +                          EIP93_RING_BUSY_DELAY * 2);
> > > +             goto again;
> > > +     }
> > > +
> > > +     /* Writing new descriptor count starts DMA action */
> > > +     writel(1, eip93->base + EIP93_REG_PE_CD_COUNT);
> >
> > Why is there no locking here? Shouldn't this be under ring->write_lock?
> >
> 
> Hi Herbert,
> this is really to tell DMA that there is new packet to process and
> gets decreased instantly.
> The lock is used to track what descriptor index should be used in the
> ring in the put and get
> functions.

AFAICS it's not safe to call eip93_put_descriptor simultaneously
since it doesn't use atomics.  Without locking in eip93_send_hash_req
two threads hashing into two separate eip93 requests will be calling
eip93_put_descriptor at the same time.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
