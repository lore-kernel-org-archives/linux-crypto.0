Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A61216324E;
	Fri,  2 Aug 2024 15:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722611820; cv=none; b=tvFpJcBfWk5h8N2pDWHu425IlLz2t92weJdvyBiX+UKQYjNLJxZIcgWOyChEwIEVC71IIFje0qj95qCGbF5Phv2CGzZF4yHOrYxnn7ytycsV1Hcf8kummTzqakkWVj1OK4WIlXvcEOxK2I/dIDWJSxKSDyjQtEGpJ+/BkGW0M/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722611820; c=relaxed/simple;
	bh=3N+B04uKCIlAgIPePxYWuNHTEndJgm1x2so5SryKEkA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=m6cWOI9gyoStgoJgk75DDigg2GGD71IBwvWMJ4PYZGAFs9hXY+5VMvs1gu8HFJBRgiZvqc7bzSjYwDD/6mhEBKjaiWlgsEWlSa+F7RLgirwTevL56Hj7OQI340gbMkFW9NW5BJGSSdbRUStdL6ta/OlqN5af7d8NzXc1AjqUEhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayq4LRjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayq4LRjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A399C4AF0D;
	Fri,  2 Aug 2024 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722611819;
	bh=3N+B04uKCIlAgIPePxYWuNHTEndJgm1x2so5SryKEkA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=ayq4LRjUyUulg1JYg2dw4nkA058tvN4M830+/fLyWIuH6LttNr95b0LI35AELwaSV
	 evoOMlVLCJe9WcWS40IgvMj32e8Z4vFvsyYFus2Psgc+2p+ngCgNGMIVPQNt9GX8tR
	 Cvqp3nQs5VCq9bnC5xW9UTBfXeh4CEIgWDj/lizXAmOxiPMRzuJPH7HqsBoH/w8mXn
	 SrcRX9XLSE2MPSqhpyrEzIxu+NUzJv4o0PLq+gpMnVK7OmE+20EQ9erZkbxlGdsdny
	 3vFkcRyJ3ISRWSXgbAUCVNJh7EYGSyqLQPHfl0L6x6aW7e75etarkzhqvjWcS204Fg
	 MCCve1jn/8M0g==
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfauth.nyi.internal (Postfix) with ESMTP id 20EFC120006E;
	Fri,  2 Aug 2024 11:16:58 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute4.internal (MEProxy); Fri, 02 Aug 2024 11:16:58 -0400
X-ME-Sender: <xms:avisZpI4XYancRwgkHIu75asiQmV8SojGgE6Q3xxP13AA5ZRxpZrWQ>
    <xme:avisZlJeEgF7EqFxGIrJKjVCwZ5ez9lqP5DspnG7_0DqVZ1_mrPi7TbclUjQDgBkH
    b0doeemUnn46KgqoWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkedtgdekiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeejjeffteetfeetkeeijedugeeuvdfgfeefiedtudeikeeggeefkefhudfh
    lefhveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidquddvkeehudejtddv
    gedqvdekjedttddvieegqdgrrhhnugeppehkvghrnhgvlhdrohhrghesrghrnhgusgdrug
    gvpdhnsggprhgtphhtthhopedt
X-ME-Proxy: <xmx:avisZhstiPww3TOhCD55MvuV78pLx_BmboXq5oSacv3F-d-FqtRPXA>
    <xmx:avisZqbiSCLL_liys-FP4zEymB9zcyp4uDN8qzcEuAv0DbNRn3gp9Q>
    <xmx:avisZgZp9TV-JY4KG8KsWcIAZU09d2egsdNaPmN50NMTuSwAnkoGqA>
    <xmx:avisZuC3R_w6smQ0Jsq1Xb3uO8p7FXWhYuZeSRlMgf9oQ17tq25VCA>
    <xmx:avisZuYb2g7_JOQvh_YodFH1VtkQJzwQyAdPe4laCgh1CHJ1kUq615q_>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id E99D2B6008D; Fri,  2 Aug 2024 11:16:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 02 Aug 2024 17:16:37 +0200
From: "Arnd Bergmann" <arnd@kernel.org>
To: "Jeff Johnson" <quic_jjohnson@quicinc.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: kernel-janitors@vger.kernel.org, "Nicholas Piggin" <npiggin@gmail.com>,
 linux-kernel@vger.kernel.org, "Danny Tsen" <dtsen@linux.ibm.com>,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org,
 "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Message-Id: <6fdd8f30-4df1-447d-9156-5d2314239e99@app.fastmail.com>
In-Reply-To: <75a526e3-3101-4319-b42f-4482ba188abc@quicinc.com>
References: 
 <20240718-md-powerpc-arch-powerpc-crypto-v1-1-b23a1989248e@quicinc.com>
 <ZqzcApbJomFTnc30@gondor.apana.org.au>
 <75a526e3-3101-4319-b42f-4482ba188abc@quicinc.com>
Subject: Re: [PATCH] crypto: ppc/curve25519 - add missing MODULE_DESCRIPTION() macro
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Aug 2, 2024, at 16:27, Jeff Johnson wrote:
> On 8/2/2024 6:15 AM, Herbert Xu wrote:
>> On Thu, Jul 18, 2024 at 06:14:18PM -0700, Jeff Johnson wrote:
>>> Since commit 1fffe7a34c89 ("script: modpost: emit a warning when the
>>> description is missing"), a module without a MODULE_DESCRIPTION() will
>>> result in a warning with make W=1. The following warning is being
>>> observed when building ppc64le with CRYPTO_CURVE25519_PPC64=m:
>>>
>>> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/crypto/curve25519-ppc64le.o
>>>
>>> Add the missing invocation of the MODULE_DESCRIPTION() macro.
>>>
>>> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
>>> ---
>>>  arch/powerpc/crypto/curve25519-ppc64le-core.c | 1 +
>>>  1 file changed, 1 insertion(+)
>> 
>> Patch applied.  Thanks.
>
> Great, that was the last of my MODULE_DESCRIPTION patches!!!
>
> There are a few more instances of the warning that Arnd has patches for,
> covering issues that appear in randconfigs that I didn't test.

Are all of your patches in linux-next now, or is there a another
git tree that has them all?

I can send the ones I have left, but I want to avoid duplication.

    Arnd
