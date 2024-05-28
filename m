Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAFA16ABEA;
	Tue, 28 May 2024 11:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716896590; cv=none; b=RMddlzr+vI1rWHcthlADrfY22H+87v2CT0DGD96yvHvKmpcgT0QdQs214UT5uY8RSaCbsxtlcx/DM/UHPxoDWEh833ymyNm2o6aRpXkXC/crMmQa4E4p1j5FuWYUu1/6/Pe3W3sPHrzlVlOHkhWe/T50QTNUgAORYKrDWExPQuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716896590; c=relaxed/simple;
	bh=xxt9e4qBmjjSBgaz5wJg1yxA/w/eio5Xu8qFL8pUrWo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=CrIQMhhBt6OYbZR/trbIXg3RlOY/2zEilc9UBfpDVn9bxo5eN44dU9t1eGsuDnHjSHCpafUIdVIGBMnMMfn3CuzamZJrcw4E67CC1YR68WjRDdv/rZCdkoYYX7DkQAXwOfXK3N3sDkGCtBRP+YVC4OQorwH7XQnpEyFx8fEGsBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWuxyqRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWuxyqRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB1AC3277B;
	Tue, 28 May 2024 11:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716896590;
	bh=xxt9e4qBmjjSBgaz5wJg1yxA/w/eio5Xu8qFL8pUrWo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=aWuxyqRrL7SBD0Lc056tIYnG0ozig3/K5u5GooJ9r4/xmVau/SM/ea/QdKRQoox09
	 lueClrfRzEM7J+7Em7MXusroTlC2otOnEGjJfRwYQEXryzupeI7fo6L+n7JNu0U9m8
	 gnr+cImb9NJ6gTkene1DusbWmNBcBXnc5qCauUFfrKk5EHQjDXzYfaIi0xFvMHzsix
	 HHrRDHXcJ+mtISGSc8tArZtDPjoCuVlTaspJRWOdlzIyDHua2DBCz9iiE3UHjkGHkU
	 0/dm1nrKO2Fw+7OW0MEch8XZWEFR0szjMRnuDnveYDWPMUhmchPtRlVilrz/cA0o04
	 OoOiejMofKX3Q==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 May 2024 14:43:06 +0300
Message-Id: <D1L91NGZIW8B.2NHUSU2BKNP26@kernel.org>
Subject: Re: [PATCH] crypto: ecdsa: Fix the public key format description
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Stefan Berger" <stefanb@linux.ibm.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>
Cc: <linux-crypto@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
 <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240527202840.4818-1-jarkko@kernel.org>
 <0e3bfc37-53d6-422d-adb0-3ee23bbb0a8a@linux.ibm.com>
In-Reply-To: <0e3bfc37-53d6-422d-adb0-3ee23bbb0a8a@linux.ibm.com>

On Tue May 28, 2024 at 2:18 PM EEST, Stefan Berger wrote:
>
>
> On 5/27/24 16:28, Jarkko Sakkinen wrote:
> > Public key blob is not just x and y concatenated. It follows RFC5480
> > section 2.2. Address this by re-documenting the function with the
> > correct description of the format.
> >=20
> > Link: https://datatracker.ietf.org/doc/html/rfc5480
> > Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature v=
erification")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
>
> Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

I think doing TPM2 ECDSA is a good test for this code, which is not
*that* mature in terms of age (from 2021 if I checked correctly). I just
try to complain at instant when I see badly documented code, when using
something new, because after a while you become blind to it...

The code quality itself is IMHO in good level and I could understand
what it is doing.

The EKEYREJECTED that I got is I think my own fault. Have to just test
the fix and send updated version of TPM2 Asymmetric Keys. Getting that
patch set to the mainline will also support quite well crypto/ecdsa.c,
which my code uses for verifying the signature using the public key.

Just adding these bits to underline that I don't think in any level
that any of this code would suck ;-) It is all good and working so
far...

BR, Jarkko
