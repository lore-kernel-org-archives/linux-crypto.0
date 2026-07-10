Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E8A2E7377;
	Fri, 10 Jul 2026 10:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783679780; cv=none; b=k9yfHTd4fUpRLdw5RMLB6I3++J3WwgPnbwLxHNVAUyjB5vt0thOwZKtaHAWca9+bVm8QVAUiHWQPq1+vMa0WN+s01BYevpuOT7LMa9SzWEwjNuJ+P9DkwwVFwolH2hvg9+apQ08gFmZZ+QH46hUZApQjKheuFweN9FWn48g14x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783679780; c=relaxed/simple;
	bh=s8e719fI1lh4iwu6ag1ePU0Hg7fs4+ScAlrOQK5mJEY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mfRg+TvRzpqmDCmgse7csasDt7c5KzbAvoJ00sf3CeYYvDqFg4nGkMIo++YmqlcNG1VJbX0rjpviTS5wMr6jVhEBtIKPoc62NOrt0boEc9KwYWU7rNMsZ/2PAl2d0fbP8HVU84PZUuhOYnY7kkQs2aynBnVvUkq9LWzaa6+yhYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=ivn/hFi6; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="ivn/hFi6"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 92E63C2F4FE;
	Fri, 10 Jul 2026 10:36:23 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id A5AC560342;
	Fri, 10 Jul 2026 10:36:08 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 61FA011BD295D;
	Fri, 10 Jul 2026 12:35:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1783679766; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=6+ULItnJf1sGBisnEhPjjWTOmY5NUXBuwBhmcIC8+UQ=;
	b=ivn/hFi6a/lBi80O3yMvQB+B5mpswIxbNWWE0pYlbkVMWfvJ0d53+YTLfaOeqhKHYWy1Lv
	IsOt5buug5pmXbjNeNF/MTreiCyObz2CGX2MhHx1i/34ziBh73lVxNvc0OOVdW2bF7k9jh
	mAQ7grUpbxuTFL5Q3Em+P2MfzyCNoJxXVeXtlypBY4aMBNHCJZXoSfR+VnMQo8m/8iIC1F
	OLt0pP5DlOs7wKDSQzWCNDPMyig2+5dli64tvbJ8L+oOteUTjVV95+9+Xo+BADYmzXipJL
	YLV1ForjqpmWJgDfcjxSBKiEV2r2yvRJBCZNCfG7TwQZ0Far/7ghqNcJOxWglQ==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Antoine Tenart <atenart@kernel.org>,  Christian Marangi
 <ansuelsmth@gmail.com>,  Conor Dooley <conor+dt@kernel.org>,  David S.
 Miller <davem@davemloft.net>,  Geert Uytterhoeven
 <geert+renesas@glider.be>,  Herbert Xu <herbert@gondor.apana.org.au>,
  Jayesh Choudhary <j-choudhary@ti.com>,  Krzysztof Kozlowski
 <krzk+dt@kernel.org>,  Magnus Damm <magnus.damm@gmail.com>,  Michael
 Turquette <mturquette@baylibre.com>,  Olivia Mackall <olivia@selenic.com>,
  Rob Herring <robh@kernel.org>,  Thomas Gleixner <tglx@kernel.org>,
  Thomas Petazzoni <thomas.petazzoni@bootlin.com>,  Pascal EBERHARD
 <pascal.eberhard@se.com>,  Wolfram Sang
 <wsa+renesas@sang-engineering.com>,  linux-clk@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-crypto@vger.kernel.org,  linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 11/16] clk: tests: Add Kunit testing for nexus nodes
In-Reply-To: <177595802905.5403.1342882536380309490@lazor> (Stephen Boyd's
	message of "Sat, 11 Apr 2026 18:40:29 -0700")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-11-5e6ff7853994@bootlin.com>
	<177595802905.5403.1342882536380309490@lazor>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Fri, 10 Jul 2026 12:35:57 +0200
Message-ID: <87se5rgmia.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hi Stephen,

On 11/04/2026 at 18:40:29 -07, Stephen Boyd <sboyd@kernel.org> wrote:

> Quoting Miquel Raynal (Schneider Electric) (2026-03-27 13:09:33)
>> Add a nexus node with a child requesting a mapped clock in the fake DT
>> overlay to verify that the parsing is also correctly working.
>>=20
>> Suggested-by: Stephen Boyd <sboyd@kernel.org>
>> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin=
.com>
>> ---
>>  drivers/clk/clk_test.c                   | 20 ++++++++++++++++++++
>>  drivers/clk/kunit_clk_parse_clkspec.dtso | 10 ++++++++++
>>  2 files changed, 30 insertions(+)
>>=20
>> diff --git a/drivers/clk/clk_test.c b/drivers/clk/clk_test.c
>> index 8a17ad0d185f..cb0071955146 100644
>> --- a/drivers/clk/clk_test.c
>> +++ b/drivers/clk/clk_test.c
>> @@ -3660,10 +3660,30 @@ static void clk_parse_and_get_parent_name(struct=
 kunit *test)
>>                            clk_parse_clkspec_1_init_data.name);
>>  }
>>=20=20
>> +static void clk_parse_and_get_nexus(struct kunit *test)
>
> of_clk_get_hw_maps_thru_nexus()
>
>> +{
>> +       struct clk_parse_clkspec_ctx *ctx =3D test->priv;
>> +       struct clk_hw *hw1, *hw2;
>> +       struct device_node *np;
>> +
>> +       /* Get clocks by index */
>> +       np =3D of_find_node_by_name(NULL, "kunit-clock-nexus-child");
>> +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>> +       hw1 =3D of_clk_get_hw(np, 0, NULL);
>> +       KUNIT_EXPECT_NOT_ERR_OR_NULL(test, hw1);
>> +
>> +       hw2 =3D of_clk_get_hw(ctx->cons_np, 1, NULL);
>> +       KUNIT_EXPECT_NOT_ERR_OR_NULL(test, hw2);
>> +       KUNIT_EXPECT_PTR_EQ(test, hw1, hw2);
>
> I think hw2 is expected? Rewrite it like this?

Correct.

> 	struct clk_parse_clkspec_ctx *ctx =3D test->priv;
> 	struct clk_hw *expected;
> 	struct device_node *np;
>=20=09
> 	np =3D of_find_node_by_name(NULL, "kunit-clock-nexus-child");
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 	expected =3D of_clk_get_hw(ctx->cons_np, 1, NULL);
> 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, expected);
>
> 	KUNIT_EXPECT_PTR_EQ(test, expected, of_clk_get_hw(np, 0, NULL));

I took your proposal.

> We're also leaking the of_node if an assert triggers so we need to use a
> kunit wrapper version of of_find_node_by_name() or do a hand code
> version of putting the node when kunit asserts.

Indeed, I just create the _kunit() variant to handle it. I see most
other similar cases in the test file are handled like that and it looks
pretty neat afterwards.

Thanks for the suggestions,
Miqu=C3=A8l
