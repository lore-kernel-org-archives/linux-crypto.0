Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4A13DA5A3;
	Thu,  1 Oct 2026 07:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840260; cv=none; b=Vc5We2QmX71wbDA812Wob8Fl9e1sZucO2ruHE6F2ggSA9wIn6CWT3GIzUUjt1TonnF/R2mRd6D8tW9e893LRl2M7VF4EE3n1+rgfSIHKeuY3aLf7JlYchFI3kwYhXeoM8p9yQCGZBNKR+LJ63/DHU350bLVFYPXswJnMIIRlBic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840260; c=relaxed/simple;
	bh=UiHlbN6JO+38M0NHYQ6YdG919LW3YMtEtW2boekRz8c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SUbXk1zqk+huuQ3rA+QgxwvmmkC0PbsUg1mLsra/nSAWT9kuv16BYP4rXX6LWaV765IdLOWZMAYI+Z2UpLLp/Sg2VgCa8OnwQA/chAvjEeoUoJJmyCFB+ntw8L9zmUMab295+VIp8PzjcSya94bm74JBgCdZMV6yvJjdh87Lscg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=hRcDw7MZ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="hRcDw7MZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=kCKep5BKuURXfC25icw8yxRw6hM7YFCvbMlLzOcfVeg=;
	t=1790840257; x=1792049857; b=hRcDw7MZipLTjJZf7QxldkWFk9yfRjfJKHruB+M4BJKBQE8
	ynzGVMeknFlicPzH4SKxla0GeFJSWhyvlR/3Y8369Adve4ulm6sliTXz8La8mBmhrNOLYWvyy2qtj
	1wxNEoV2CmN1t/aZ17dtLTKgioDvI7Xm3RJe/YfdCCuhGXwVks3WZJys3T9ZPOufkH1dIRXAxZqiD
	4zK2EksgDT3uFP5YBaOqg+ktv/j710OK4HUUvB+WTHN9lDXmjGZ5U6ZJSVnMUFu9q+wL6webeQaJi
	woRNKXOVluxyQafTdh5OeMcQpHNAISgLmtsmucR0FADiaSaAImc4u8zv6WqUbY7g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCBM0-0000000HWrR-2m9Q;
	Thu, 01 Oct 2026 09:37:20 +0200
Message-ID: <47ebbd91b4bdb57723be40608349eff9ced1f34b.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/5] wifi: add opt-in FIPS exception for iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	miriam.rachel.korenblit@intel.com
Cc: ilan.peer@intel.com, emmanuel.grumbach@intel.com, 
	linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Thu, 01 Oct 2026 09:37:19 +0200
In-Reply-To: <20260930120829.383408-1-jtornosm@redhat.com>
References: <20260930120829.383408-1-jtornosm@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi Jose,

I'm super confused by this, it looks like mostly random code changes to
not really do anything useful any more ... Nor do the code changes seem
to actually be doing what you describe.

> Commits 5241526dede9 ("wifi: mac80211: don't send keys to driver when
> fips_enabled") and 0636800c8ee1 ("wifi: iwlwifi: disable certain features
> for fips_enabled") disabled WiFi functionality under FIPS mode because
> Intel firmware autonomously sends some management frames without
> FIPS-validated integrity protection.
>=20
> While this is technically correct, it leaves FIPS-required environments
> with no WiFi connectivity at all, since WPA3-SAE mandates MFP and without
> MFP_CAPABLE the client cannot even associate.

Arguably, that's what FIPS wanted. It mandates that you cannot give keys
to the device since it's not certified, and therefore it cannot do the
necessary functionality for these connections.

I can understand why you don't like it, and I guess we can try to find
ways around it like what you fundamentally seem to try to be doing here,
i.e. formulate an exception to the policies.

But I think you should actually formulate the exception that you *want*
first and then implement it, not randomly poke holes into the code and
call it done.

> Patch 1: Adds the fips_exception infrastructure (boot parameter,
>          read-only sysctl, fips_allows() helper)

Not my domain, but I'd argue that design documentation I ask for above
should somehow make it into the documentation for this parameter so taht
administrators can actually make an informed decision.

> Patch 2: Gates the mac80211 key blocking with fips_allows() so keys
>          can reach the firmware for data traffic

This patch is mostly wrong. If the exception is called "MFP" then
there's no need to pass all keys, and in fact the way you implemented
it, I don't even see how it doesn't end up with HW crypto after all.

> Patch 3: Gates the iwlwifi feature disabling with fips_allows(),
>          restoring MFP, Beacon Protection, EHT, 6GHz, A-MSDU sizes
>          and MLO support

This is also partially wrong - you didn't really understand this and
just undid everything?

> Patch 4: Best effort to force software encryption for unicast
>          management frames (CCMP/GCMP). It sets
>          IEEE80211_KEY_FLAG_SW_MGMT_TX on pairwise CCMP/GCMP keys when th=
e
>          exception is active, forcing mac80211 to encrypt unicast robust
>          management frames (SA Query, deauth, disassoc) in software using
>          FIPS-approved CCMP/GCMP, the same mechanism used by ath9k, ath5k=
,
>          carl9170, mt76x02, rtw88, rtw89, rtlwifi, ... and other drivers.

This makes no sense at all.

> Patch 5: Reduces firmware decryption error message to debug level in
>          FIPS mode. Same as v1 patch 2/2, accepted upstream but not
>          yet landed.

That seems reasonable.

I'm not going to reply to the individual patches, but I observe that you
didn't understand IGTK functionality, WoWLAN, A-MSDUs, or maybe
encryption offload in general. From what I can tell, your patches are
mostly equivalent to turning FIPS off for wifi.

I don't know where to go from here. I don't think I'm going to teach you
all the necessary things here in the context of an upstream review, or
redo the patches correctly myself. Maybe you can approach Intel over the
distro channel Redhat has and ask them to help. Which will almost
certainly end up falling back to me, but at least then we can support it
and it's accounted for.

johannes
