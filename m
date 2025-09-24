Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33B7296BAA;
	Wed, 24 Sep 2025 08:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758703478; cv=none; b=f4yeBmmncqo44gCGH3tCesqLOEicAsuu0H/EAb6E6uNOcYKvlda2l3K8coN93wvp8E3XslGhscjIxVPg0KPFEO0cW2w+j/rJbcgrODCGW3NeA094Hm9KcKgNwZx1gBImRBb3+JDWqIS2acBlH3oMxTVaWgzLeqyWjDu1sn+WPdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758703478; c=relaxed/simple;
	bh=7E6QK7pHBc6Tj/OKkybEC4KJUY708g6FvcrorHKD8Ws=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uWM2y8loH6sy0oROCaOWl16ncKnRg5kzanFz8Z0oKyqQ60H/sjzBDhtVD5Ocxkv7BIXIHN6Gzo4NLto8lbIy5045CZPvjqorz3UciA0WK71y43hSMGxrKUqMIQakbrsLV78F8eVvLffEa6RAN5I3KQNbI3YZCbia8IH7RwDswyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=kL3Mt+lG; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="kL3Mt+lG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7E6QK7pHBc6Tj/OKkybEC4KJUY708g6FvcrorHKD8Ws=;
	t=1758703476; x=1759913076; b=kL3Mt+lGpdHAjiOovvxi8JJyoGW4SHE63pI8DDv08Jmb7b5
	KOK79K2vGYyHXwk74I+uA2bHmDnz1o7vqzvE9uck0HB4p3RJcdX3V87MgayTiIMIbWYoGMKIUAnvo
	l8vcEUOuIO89dn8H16udI9b0a7XzJz8ZScafhvMAl/8DRXSssiEhP1TZzZ1+bYok++3GZW7PjlA8U
	ENnsOf/L+L8/OlIHib70SkgUyAxeM6SsPH3x0tinSFn9qTSNPvjPAsbFeRyofMwzDYXk+g18HsSLg
	G2dPMNPN8AiH+Tx7ucaLR2s9zHZ5Z/ssL0bdXq9VhKjqZNT239HQxEl4qMU71Jsw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1v1L6u-00000008TYW-2seR;
	Wed, 24 Sep 2025 10:44:25 +0200
Message-ID: <8d2ec79561f5aa17403014a298bb9188f904e489.camel@sipsolutions.net>
Subject: Re: [PATCH v2 02/10] kfuzztest: add user-facing API and data
 structures
From: Johannes Berg <johannes@sipsolutions.net>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	glider@google.com
Cc: andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org, 
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com, 
	dhowells@redhat.com, dvyukov@google.com, elver@google.com, 
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
 jannh@google.com, 	kasan-dev@googlegroups.com, kees@kernel.org,
 kunit-dev@googlegroups.com, 	linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 	lukas@wunner.de,
 rmoar@google.com, shuah@kernel.org, sj@kernel.org, 	tarasmadan@google.com
Date: Wed, 24 Sep 2025 10:44:22 +0200
In-Reply-To: <20250919145750.3448393-3-ethan.w.s.graham@gmail.com> (sfid-20250919_165803_858771_D7FB8768)
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
	 <20250919145750.3448393-3-ethan.w.s.graham@gmail.com>
	 (sfid-20250919_165803_858771_D7FB8768)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2025-09-19 at 14:57 +0000, Ethan Graham wrote:
>=20
> + * User-Provided Logic:
> + * The developer must provide the body of the fuzz test logic within the=
 curly
> + * braces following the macro invocation. Within this scope, the framewo=
rk
> + * provides the `arg` variable, which is a pointer of type `@test_arg_ty=
pe *`=20

FWIW, git complained about trailing whitespace on this line.

I'm trying to apply this and integrate it with ARCH=3Dum and honggfuzz
(because afl++ doesn't work with -fsanitize-coverage=3Dtrace-pc and I have
issues with clang right now ...). Fingers crossed :)

johannes
