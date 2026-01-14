Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C5630EF72;
	Wed, 14 Jan 2026 12:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768394266; cv=none; b=H12Ir2+odVEHIoTS1btHN457qgenzt6Ixhl/kenBnpN2Ip6mtbsenbspjg9GCOE4bakv4C6ybpVDPPnsAiV9FiLLn/sV259vW9OT07QkayMRyyI3QBILCst9tgKhz9dfEeq+0PJY+4GRbzVqMzBXrVIETtzfaDNbv7Ekb/Zuoks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768394266; c=relaxed/simple;
	bh=ivImLx0IMwWptsei2EtrkPEC8sK7x+WsxIR0q4hvYGs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CtRZTlleNl6WwUZBPDAxi6R9xb6ksnTUoyH/wMTshmzD5gfc7ZVa9mXj9RhgP1NZ5z+gyXRurdxJhnaPus+dvzDBZRrdf7gd6+9i6fItYmGFs1ahmJtvLOU5Sw4utgXv7AsvKdBlUHMc10zBL1/WoPD/tKsspkQjA7a09RJP5zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=iYiYgR2r; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="iYiYgR2r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ivImLx0IMwWptsei2EtrkPEC8sK7x+WsxIR0q4hvYGs=;
	t=1768394264; x=1769603864; b=iYiYgR2ryHZpfMcskwNwTD9UUy8xlKsuDRWGSCMUjJ3e7Gl
	T0y9Ce8CVLzBgSrTxfgvtpdWSVmuSTBWSYDJbQ3uzRI5BubzjNxbzNtHxim4X4p4r4epcwV8nAmgw
	pnlehIdfDbsGsZYmhTXqPZ4A4uuTLch9S5yBwGZtJaWRV5k5NjY91/YLqysj/LZ8XB6zGQDSmNx1z
	1hKUflBDfk+qnqaf0j+CpKHI6LhZlyXlxHktkKIVJcRFm9x5ZvpqL4fpC2fB22cgbA17dj377XeOI
	1JDBQ0VcWk/ihr2vwJrjNQab7ZQLUSvZ7Q+csgCxvU8g1L+ejaUDPHzkitRLvHdg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vg07s-0000000Be2H-0lg3;
	Wed, 14 Jan 2026 13:37:28 +0100
Message-ID: <27c35b1f39c4cfaaf3b8322bbeb793c268fe4b6e.camel@sipsolutions.net>
Subject: Re: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com,
 dvyukov@google.com, 	ebiggers@kernel.org, elver@google.com,
 gregkh@linuxfoundation.org, 	herbert@gondor.apana.org.au,
 ignat@cloudflare.com, jack@suse.cz, jannh@google.com, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, 	lukas@wunner.de, mcgrof@kernel.org, shuah@kernel.org,
 sj@kernel.org, 	skhan@linuxfoundation.org, tarasmadan@google.com,
 wentaoz5@illinois.edu, 	raemoar63@gmail.com
Date: Wed, 14 Jan 2026 13:37:26 +0100
In-Reply-To: <CANgxf6yGDGAD9VCqZyqJ8__dqHOk-ywfSdhXL5qATfxnT-QGFA@mail.gmail.com> (sfid-20260114_132852_914833_479AECE9)
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
	 <CANgxf6yGDGAD9VCqZyqJ8__dqHOk-ywfSdhXL5qATfxnT-QGFA@mail.gmail.com>
	 (sfid-20260114_132852_914833_479AECE9)
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

Hi Ethan,

> I wanted to check if this v4 aligns with your previous feedback regarding
> the tight coupling with userspace tools.
>=20
> The custom serialization has been removed entirely along with the bridge
> tool. This series now focuses exclusively on passing raw binary inputs
> via debugfs with the FUZZ_TEST_SIMPLE macro.
>=20
> The decoupling eliminates any dependency on syzkaller and should help
> remove some of the blockers that you previously encountered when
> considering integration with other fuzzing engines.
>=20
> Does this simplified design look closer to what you need?

Thanks for reaching out!

We're doing some changes here and I also need to focus on some WiFi
features, so I don't really know when (if?) I'll continue working on
this, but yes, this definitely aligns much better with what I had in
mind.

FWIW, maybe for new people on the thread, last time I was considering
building ARCH=3Dum in a way that it would run into a (selectable) fuzz
test, fork, and then feed it fuzzer input coming from honggfuzz [1]. I'm
handwaving a bit [2], but this would basically bypass userspace
completely and let us fuzz any of the tests in the kernel with "reset"
for each fuzzing round.

[1] selected because it's compatible with what the kernel does now with
kcov for coverage feedback, afl++ currently cannot deal with this for
some reason

[2] because I hadn't quite figured out how to make UML a single thread
only and get rid of the userspace running inside of it


Regardless, definitely yes, I think the design is much simpler and even
if I don't end up integrating honggfuzz this specific way, I do believe
it will make it much simpler (and more performant) to integrate with
other fuzzers.

johannes
