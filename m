Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B96368269;
	Wed, 27 May 2026 15:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779896580; cv=none; b=VPX6kOsPUC1tJJlaV6duMhoG2M8dZp2ldTqfe12lhqRh3W2oq+g1XM0tuQaRldTsEkJXuKoVNpn7dDIPUmZ25dI/u51NS85WJCQw1/zWF0qYMLh4to3+r0jo6Uf8BwQPIqfLy1PwjkWCI5xWe3OhN7mF+f441XwpIdPR2yUdwzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779896580; c=relaxed/simple;
	bh=BFbWywArvKGU/zZDWh8taCN56dB+G0SQKF42EH07a/M=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Kg/QaNIcj+bCYZHUfNRh3Kp53i1CawS8QxoEYlg8bKutrKwWeZPrH0TBd/KW3Y46sgtIm0YBUBejhnTRc5cNYzG07Y9j11+ycuGv3tIX2vYVqdNehJEYmAz665S/KS0hm1hJZOHf/YuZAiqyjcLa/TvMi/qb7DGwKBfog+Mk48g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndBR25q6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndBR25q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933151F00A3D;
	Wed, 27 May 2026 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779896578;
	bh=KQeaqW1+PAxLRkQR+E6xlA/aozp/Xw69MJj1v5/LkC4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=ndBR25q6q7st0Qvnc+uNw5sdJKl7URqJw7i4E/N9IoVzrPerkayXj3fRCJzXs3Dyw
	 +j5kMU3+LBdQZBcZQHW6PAQq18LcdoUSdRFq7eFDMsT21+DKa0LH6rckjoR9Lsr6Xb
	 tQhRByjYkFNp27NdaZnNDyTBN5QAvcGSpW0U8v3zmIpw+dblBDdOKgQAlQ8Jl1yz/O
	 kn+AU+ml7+hsSSt/UJwmhxv9NAr87s9D3l0vynrzywoJGqqsR1ROmeMhFeHEqbwSQy
	 q2nBDKms8p/eE0kTi83rMQgUj/a1Qskb/O1jIF/C+TUKCEGexyE1ViRQU6Ueg+ImxF
	 kNLG1cfCrKoiQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id BDD82F40076;
	Wed, 27 May 2026 11:42:57 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Wed, 27 May 2026 11:42:57 -0400
X-ME-Sender: <xms:AREXaoSI_p6MhV985PW_wnOupdQuItqMXUu5b4oHXNrwPdVEW9Edkg>
    <xme:AREXagmMRY7U3rT6dv6B-js5z5_6N9vxep6xjPvq8SL0em7QWhCGhHOIy6mqFlDCT
    NKmU1W62fn3V3ljLnOxGp3x0kNuNlHJw90YmCydAlEq61VvRITzxsI>
X-ME-Proxy-Cause: dmFkZTEhymfpeOVTwNQAvYsfWvZQF5DpQe1q8xYhnt+2bWmmC+4lU/6dDjTWC4SiAIlF4s
    0IRV5gi0tK0Oo5LJ2FOrbozPQclpv2H5/pCfhN1czgPZBqcO6i7bIg6ddq49zWDADCqcjz
    TnnmqZM9RxdFZF3aS+0ehDM89TBKA4fITpBXQOI/8UJWjoJbbgYPp0lwwiLJAB4r486+jq
    9DpAKJQKSJEqRRlaoMpD9yRQNB+1+lFoTQR1jjlhUXXQdzkVDIXk24IrCbiyymplWWUqJB
    W6iLWuuYYP0h0StXS66s3zUvGbqEPpN9yORvLQIIoilaITZuDnlVwjEVe3B12LMl7kDbUm
    A9qS6Oo860prPkD9aurWfTyX31DyKRsTq+MvtZPlJxroJ0VhGX56DoWUdHOtTuj5oc0kts
    qNW8ASovQ9M6SDQA9NAhFYi/C7oLGWy6GnNjmGcjufxnCSEgd6MtGgMron3E42zCCWju0E
    9St93KSpPr6kSDxaeroe3tXhoFbQaBngcYC7wiRFmkqgVmvWP+OOytOOqKexIn3mS781Bd
    /fvHUzBZ+dpqeRqBXYegIQcVogBdGsTfCylY0odK+yK6eXLeTWTKyr21zUlLwyCqR8l7ok
    A1Fi3O5EWYmhfH264GlmyN9cdkd3ciMn3hVIDUOTHhIfCht/R6lm2npbV+PQ
X-ME-Proxy: <xmx:AREXaqPNYQ3ehPYiUSJhMpYJrahq7EFfTV48yu1f8x2T9sya3JTRfQ>
    <xmx:AREXat61NYt0NrtPVptOh2Lw4Q_JgWvtp_QkdoawRss8PyzIXN8HkQ>
    <xmx:AREXalgTbDVZKjvmD5SAygCe7TuB1S8ISQ3H3Hgb_Ia1s7kb2cFLBg>
    <xmx:AREXaqcCJw8w1f2EKTFL74hzi2KmVZU5lPD_FGhh2mQJP4IBQdcKdQ>
    <xmx:AREXalwn-YzFSeOZHPzeegFMfslQ3DR_dNCmbCvnhb2wFmQUoIAgUiSq>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A0D851820082; Wed, 27 May 2026 11:42:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 27 May 2026 17:42:37 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, "Christoph Hellwig" <hch@lst.de>
Cc: "Ard Biesheuvel" <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, "Russell King" <linux@armlinux.org.uk>,
 "Arnd Bergmann" <arnd@arndb.de>
Message-Id: <83ee320a-972e-4f1b-b3bf-8ede24013505@app.fastmail.com>
In-Reply-To: <20260527015754.GA13078@sol>
References: <20260422171655.3437334-10-ardb+git@google.com>
 <20260422171655.3437334-17-ardb+git@google.com>
 <20260423074712.GC31018@lst.de> <20260509202354.GD11883@quark>
 <20260527015754.GA13078@sol>
Subject: Re: [PATCH 7/8] lib/raid6: Include asm/neon-intrinsics.h rather than
 arm_neon.h
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 27 May 2026, at 03:57, Eric Biggers wrote:
> On Sat, May 09, 2026 at 01:23:54PM -0700, Eric Biggers wrote:
>> On Thu, Apr 23, 2026 at 09:47:12AM +0200, Christoph Hellwig wrote:
>> > On Wed, Apr 22, 2026 at 07:17:03PM +0200, Ard Biesheuvel wrote:
>> > > From: Ard Biesheuvel <ardb@kernel.org>
>> > > 
>> > > arm_neon.h is a compiler header which needs some scaffolding to work
>> > > correctly in the linux context, and so it is better not to include it
>> > > directly. Both ARM and arm64 now provide asm/neon-intrinsics.h which
>> > > takes care of this.
>> > 
>> > 
>> > This could potentially clash with the raid6 library rework I'm doing
>> > for 7.2. Although git has become pretty good about renamed files, so
>> > maybe it won't be so bad.
>> > 
>> 
>> I think this patch also breaks the userspace build of lib/raid6/.  Which
>> is going away in Christoph's series anyway, but maybe it would make
>> sense to drop this patch (and patch 8 which depends on this, I think)
>> from this series for now?  That would make it a bit easier to take the
>> rest through crc-next.
>
> Ard, are you okay with me applying just patches 1-6 to crc-next?


Yes that's fine - thanks.
