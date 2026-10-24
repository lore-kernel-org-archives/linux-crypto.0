Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792884138;
	b=mxl/Hqw/YApBUFP8FxjmYwyKSTWhRvNy54HZpzRrQGsA79LxjsOOl75vAfaFHFyH8rml
	 BMUDJL8C8Uln/6NBzYA/qUj/zWFUy9EqiHg9tnTH/LBEMN5lKG0b1x4XIbFpsVUOzyv25
	 rD8g5FbydMYb0RVemi/l/MQygy6RClch+J/XEaqwXTWkKfRAcp2mWAZKYrf0QlbuADGBz
	 Uy1pV0BarbqPsaiR58SInag30ph1fxaGEzJzOHB2R46jGR4GgW6MM++VMXr7mvNhX4cgV
	 JLrj5yjCM4P0rikVc3yW7l3YQa6WE8/FS2uf2NDoA8xeILW3+IdHlUIPXVsWBldq6Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792884138;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5MaoT/8ksd5IsjEEmV0ldmSolxIyl6QJJxD+GIBwMwE=;
	b=KEXECmt2WNt33b3jDankEE8JgXM3LCWhfvv8tBHQXojfR/uwJVlqzmvUi3u+Hpi6N4oi
	 hO5hQfM9ZTGB43FunjL+TW6NSeNIlIocdpD/Hn5JfmJuH/Z/7JB86mfkqKlMAxTdKOdPM
	 abQSvla7HXXSBcBomcvFXKVsS8k5Ks4NKNlYx1GNNBUYTk0wjIPjlxVS0VBZeNOi22tz7
	 T+R94DoJ42KmIxru22zYDJo9Larr+U8ugv/gPjwY5kdrc/z3sWO+91tGPQI87h2cnnPqy
	 3n2KH4xahKZEvcY68dpMbmvU+zRZrVnaggOTs7JXmthgIG538/PQ8Hd4XLqxlAJ3RZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EXYS2+DJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D260606A31A;
	Sat, 24 Oct 2026 23:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EXYS2+DJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CD81F01825;
	Sat, 24 Oct 2026 23:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792884137;
	bh=5MaoT/8ksd5IsjEEmV0ldmSolxIyl6QJJxD+GIBwMwE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EXYS2+DJFWQOCXum7CIb934dxkSdKYNVFBnz5OIN9cQf9r0RWZ0RONAqTSBsxaON4
	 hEf8R2Tr2fleLnNcbZ8j7mo5Pfx+tsryRqPELiS4kLzm1ktWamRUHnPQCrdYUAqgZe
	 eOg5cs2yvGh12ujtfLQZ9EJ/w7MGO+rggVweNsnlpcjG0C/9xg9KqMfItk2rO+cjK4
	 dKaSOVOpq+2KvK/I3T7DASqVw8G8S3ZNWFJwTKif0sbzQRNB/I0TOyFT3bapU0+2GU
	 DAqzzFuNlbPkdKvGEvedfebWAfqbYJZDZm1s6U14rGzH3mbQ0t6iFVLnxWKIIL4Sns
	 4ETMrIWBkDClQ==
Message-ID: <sashiko-outbox-183943@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] hwrng: rng90: add KUnit tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Patrick Tudor" <ptudor@ptudor.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Olivia
 Mackall" <olivia@selenic.com>, "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: devicetree@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20261024-rng90-submit-v1-v1-3-e265cfabc9af@ptudor.net>
References: <20261024-rng90-submit-v1-v1-0-e265cfabc9af@ptudor.net>
 <20261024-rng90-submit-v1-v1-3-e265cfabc9af@ptudor.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 23:22:16 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] hwrng: rng90: NULL dereference in rng90_test_exit() if rng90_tes=
t_init() fails
--

commit 738c911c8957ee3bcb09ed18f6daa72a41daed79
Author: Patrick Tudor <ptudor@ptudor.net>

hwrng: rng90: add KUnit tests

This commit adds built-in KUnit tests for the RNG90 hardware random number
generator driver using a scripted I2C adapter to exercise command framing,
CRC validation, polling, recovery, health failures, and power management.

> diff --git a/drivers/char/hw_random/rng90-kunit.c b/drivers/char/hw_rando=
m/rng90-kunit.c
> new file mode 100644
> index 0000000000000..f6daffb2e3d97
> --- /dev/null
> +++ b/drivers/char/hw_random/rng90-kunit.c
> @@ -0,0 +1,820 @@

[ ... ]

> +static int rng90_test_init(struct kunit *test)
> +{
> +	struct rng90_test_context *ctx;
> +	int ret;
> +
> +	ctx =3D kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +	test->priv =3D ctx;
> +	ctx->test =3D test;
> +	ctx->adapter.owner =3D THIS_MODULE;
> +	ctx->adapter.algo =3D &rng90_test_algorithm;
> +	ctx->adapter.algo_data =3D ctx;
> +	strscpy(ctx->adapter.name, "rng90-kunit", sizeof(ctx->adapter.name));
> +	ret =3D i2c_add_adapter(&ctx->adapter);
> +	if (ret)
> +		return ret;
> +	ctx->client =3D i2c_new_dummy_device(&ctx->adapter, RNG90_ADDRESS);
> +	if (IS_ERR(ctx->client)) {
> +		ret =3D PTR_ERR(ctx->client);
> +		i2c_del_adapter(&ctx->adapter);
> +		return ret;
> +	}
> +	ctx->priv.client =3D ctx->client;
> +	mutex_init(&ctx->priv.lock);
> +	i2c_set_clientdata(ctx->client, &ctx->priv);
> +	/* Never register this predictable test source with the hwrng core. */
> +	return 0;
> +}
> +
> +/* Verify the script was consumed, allowing a final busy step at the dea=
dline. */
> +static void rng90_test_settled(struct rng90_test_context *ctx)
> +{
> +	if (ctx->next < ctx->count &&
> +	    ctx->steps[ctx->next].repeat =3D=3D RNG90_TEST_BUSY &&
> +	    ctx->steps[ctx->next].hits)
> +		ctx->next++;
> +	KUNIT_EXPECT_EQ(ctx->test, ctx->next, ctx->count);
> +}
> +
> +static void rng90_test_exit(struct kunit *test)
> +{
> +	struct rng90_test_context *ctx =3D test->priv;
> +
> +	rng90_test_settled(ctx);
> +	i2c_unregister_device(ctx->client);
> +	i2c_del_adapter(&ctx->adapter);
> +}

[Severity: Medium]
Can rng90_test_exit() dereference a null pointer or repeat adapter teardown
if rng90_test_init() fails?

In KUnit, kunit_run_case_catch_errors() invokes kunit_try_run_case_cleanup()
-> kunit_run_case_cleanup() -> suite->exit(test) even when suite->init(test)
returns a non-zero error code.

If kunit_kzalloc() fails in rng90_test_init(), test->priv remains NULL, and
rng90_test_exit() will dereference ctx in rng90_test_settled(ctx),
i2c_unregister_device(ctx->client), and i2c_del_adapter(&ctx->adapter).

Additionally, test->priv =3D ctx is assigned before i2c_add_adapter() and
i2c_new_dummy_device(). If i2c_new_dummy_device() fails, rng90_test_init()
calls i2c_del_adapter(&ctx->adapter) and leaves ctx->client as an error
pointer, after which rng90_test_exit() will run and call
i2c_del_adapter(&ctx->adapter) a second time.

Would it make sense to assign test->priv =3D ctx only after initialization
succeeds in rng90_test_init(), and check for !ctx in rng90_test_exit() befo=
re
cleaning up?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024-rng90-subm=
it-v1-v1-0-e265cfabc9af@ptudor.net?part=3D3
