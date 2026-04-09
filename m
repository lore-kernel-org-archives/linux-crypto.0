Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BBA3CCFC1
	for <linux-crypto@vger.kernel.org>; Thu,  9 Apr 2026 12:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775738796; cv=none; b=nwZEDaktvq4FLG6dk+vqkOh/LUss6F3X+sTyIGkhJa54C1u4D+V1xx7x30hXTbuLvalS6v5n28ldJvwOsWBiiFWou+urpdgfFRYBuQNQJz22lV+Pdzehowkb/rGWAQbj3RLex0lQADA9wqFizzgoTaxe5zAhcWEfncsOEHlgt7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775738796; c=relaxed/simple;
	bh=GYbDUWp3SZzI4OwlK2TCKdEpUphnA+1nhWGm7+DWdFs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=G/LfmUYPsoBnjCkl3uivx71F7TmCKiTRA8Q1Vdw4sjGNS6JJUK6nHV0my2tdVeUANmXh9RAfq5auUmX1ntqIjAH3VoClSyqraLqPXFPTLrjrwA+W7ib/m70T8OGTaE01aSfXV4n2uUzAMrJdCj7oSFcplMbDFC4Lh3w3aThmpn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UK4xtk0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UK4xtk0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E90C19424
	for <linux-crypto@vger.kernel.org>; Thu,  9 Apr 2026 12:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775738796;
	bh=GYbDUWp3SZzI4OwlK2TCKdEpUphnA+1nhWGm7+DWdFs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=UK4xtk0lPHiuLi8fKrx4pFc0cy7zO1j0/94yiXk0OK1g5ERctKyxE0b5kqZy1ysGm
	 Ks+ct/i0h1ACngq9afgGszBwyTg+dZ3z7PR7g2z4zfNpDCA//x4E/z9/uUA3Etl1JL
	 uerGWzyC3HLSLudWqV08ClJOmR2xyTuYWm7ZR6y4J+C0Bqcv+CJ3qjS07Qb4vr9CSi
	 PiATHSqvg/7Lyzqshvsbs2xMn2wonlscJUTl6I1DpsQW+mw9er3HV6WveLNnlGS98W
	 F/i6rv2TUbt8wLLwe35oqrhe6sYqgzqLUqZO36PAC6NoOyTzmnAR+jLfuR4x9rlheb
	 vwR6PkzJdep0Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 69592F40074;
	Thu,  9 Apr 2026 08:46:35 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 09 Apr 2026 08:46:35 -0400
X-ME-Sender: <xms:q5_Xaf39ALOV8lVX38Y32UrY-6i78Vr-6QkiRMqNjIQLQJeVMgFfFQ>
    <xme:q5_XaY5GaIKRJnLXmkAzkfoFtZhWUXv1Ef-v2aysLo1F0S1Obud4csjpnN3rN7Ppw
    K5eKbcnNPkeN1gxjZl2O6JDkIUdqogdMiXbtnMIcBF3tk2vD88ahp0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvieehvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpth
    htohepshhimhhonhdrrhhitghhthgvrheshhhoghihrhhoshdruggvpdhrtghpthhtohep
    vggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopeguvghnghhlvghrsehlihhnuhigrdhisghmrdgtohhm
    pdhrtghpthhtohepfhhrvghuuggvsehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtoh
    epghhlrghusghithiisehphhihshhikhdrfhhuqdgsvghrlhhinhdruggvpdhrtghpthht
    oheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:q5_XaSE_j8wQIdJMhBWtzpO2VN-pz6nNfy-et5WZXJashbwd8oTuEQ>
    <xmx:q5_XaXB65zkrYeRTiaaHDiIbbW1_2f3nd_h2_8TQ7BpSca1Yys5byQ>
    <xmx:q5_XaUwPR2Y8KC6TQYnz-6Mp_tWo8S2rQp12tM_TbIJS_83IZyvyyQ>
    <xmx:q5_XadcSkJYzlR6Jiw_gnqbi2F4gb6wwxNeBpy_gkbfU4wkypLVPbA>
    <xmx:q5_XaZu343smsMA784xcQD5eej3RBtIjLWibVpoddMxQ6zTndogbQwoI>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 457F6700065; Thu,  9 Apr 2026 08:46:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ADDaTlyNV6JN
Date: Thu, 09 Apr 2026 14:46:15 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
 "Simon Richter" <Simon.Richter@hogyros.de>
Cc: "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>,
 linux-crypto@vger.kernel.org, "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, x86@kernel.org,
 "Harald Freudenberger" <freude@linux.ibm.com>,
 "Holger Dengler" <dengler@linux.ibm.com>
Message-Id: <d1341501-883d-48f1-8a42-92934459cce4@app.fastmail.com>
In-Reply-To: <20260327172423.GA3407398@google.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <0982d4341f58e2f1181bc472dc9c9d8542148e3c.camel@physik.fu-berlin.de>
 <20260326202733.GA2657@quark>
 <35e00d0f-85f6-457a-99b4-703caf3e1e6e@hogyros.de>
 <20260327172423.GA3407398@google.com>
Subject: Re: [PATCH 0/3] crypto: Remove arch-optimized des and des3_ede code
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 27 Mar 2026, at 18:24, Eric Biggers wrote:
> On Fri, Mar 27, 2026 at 06:59:21PM +0900, Simon Richter wrote:
...
>> However, even from the "crypto" perspective I believe that we can't get
>> around support for asynchronous offload devices, because of mobile devices.
>> I suspect no one would be building dedicated silicon for asynchronous AES
>> into mobile CPUs if that wasn't worth it somehow
>
> They do it anyway.  It's a checkbox feature.  I.e. the purpose is for it
> to be advertised on a list of features.
>

Often, h/w crypto IP blocks are part of the SoC-specific authenticated/confidential boot chain, which is anchored in the mask ROM. Nobody wants to put software implementations of RSA and AES in there, and so it offloads the crypto processing to a h/w block instead. Since the h/w block is there, it can be used by the OS too, but that doesn't mean doing so makes any sense.

Only h/w accelerators with multiple internal queues can generally keep up with the CPUs and network/block I/O in a meaningful manner, and those are quite rare IME.

