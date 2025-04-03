Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDDF178372;
	Thu,  3 Apr 2025 03:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743650412; cv=none; b=CzoR28FlyWuBBy4sHInqDHHLbIvrL9/Yvimlj8VzMLj5oAwtWHU2SN/KI9OX+1oEze5f0wudTCThUJqFIHhwK7wcVf00Wd0N+4dJqP3JtIpBRqY4odlEn3q+KAGt/zQpygmWqrudhxTE5BfWAovpnekNfBnsoqvLdaxntgGS1z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743650412; c=relaxed/simple;
	bh=nZPjGeeNY41NHfEL+/E2awllHfI5qwO/hb+EcnJkNT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dln/X06ab1AYRpLbly4itGXMyhu+J8ta4mEBrV8nIUAFRUqkiuc39f1aGzxYTrG9Xkzs18ciUoeojk9JxxbbwHHfHF5Vp/aATVlDu7tYevSyM3lL5UTBCIkDZUPZFNxyUPqvpNhznQRJtlr/4TqdEH57ikS/1wD2QLDXIfFZ5Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZJfckAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZJfckAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1861AC4CEDD;
	Thu,  3 Apr 2025 03:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743650411;
	bh=nZPjGeeNY41NHfEL+/E2awllHfI5qwO/hb+EcnJkNT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dZJfckAur6c3yURAu6URYMSiYDiMvEwH2q41TEGk7djnAtk7I1KkmIVdlChP6c2Mv
	 4n7QfasQM3GoGUH1+YK8YaZwxMO1K64orpDsH1gqGl2zKyZmbIdKFm4EHRE99S6ura
	 /QMBphJVQi8+KZAVzRCAFrm4iC5lFRza+6Ee7/gPo9Nusc+6jjqU+I1RdnnjpPXOdp
	 07kfwfFgzv+6MUYPuHtE1HJPiBFzZpMmz+LDH6m6onhq+XQ6RxWooLkMescljw87Op
	 1DLlItfzv5vvVctoIWs81jTA8phkEhjKZEFu2wALig4L9BNn2AUm64OsmU+cyz5HxC
	 /v3pxpxwbSbBA==
Date: Wed, 2 Apr 2025 20:20:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
Message-ID: <20250403032008.GA129577@sol.localdomain>
References: <20250402002420.89233-1-ebiggers@kernel.org>
 <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
 <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
 <20250402171930.GD1235@sol.localdomain>
 <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>
 <20250403021453.GA2872965@google.com>
 <Z-344xAsx1uTE9OK@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-344xAsx1uTE9OK@gondor.apana.org.au>

On Thu, Apr 03, 2025 at 10:56:35AM +0800, Herbert Xu wrote:
> On Thu, Apr 03, 2025 at 02:14:53AM +0000, Eric Biggers wrote:
> >
> > It's not the 90s anymore.  Crypto is fast now, and used ubiquitously.
> 
> I have to say that you've done a great job in improving crypto
> performance on x86 and I'm very pleased with being able to
> encrypt 256 bytes in just over 100 CPU cycles and doing a
> whole page takes less than 1000 cycles.
> 
> But this is only possible with SIMD instructions which we do not
> support in hard IRQ context.
> 

What?  Take a look at siphash_1u32(), for example.  That is crypto, and it is
fast.  It doesn't use, or need to use, SIMD instructions.

Also, riscv has scalar AES instructions.  (They aren't used by the kernel yet,
but they could be.  The CRC code already uses scalar carryless multiplication.)

Obviously, it's also very common to really need the SIMD unit.  That's the way
it is.  But those are not all cases.

Also, as I said already, x86 does support SIMD instructions in hardirq context
in some cases.  Whether anyone actually uses that, I don't know, but it is
explicitly supported.  Check out irq_fpu_usable().

- Eric

