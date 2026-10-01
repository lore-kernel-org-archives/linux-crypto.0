Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3372C299943;
	Thu,  1 Oct 2026 14:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863603; cv=none; b=Vvv+M13gFz3X9KMulrGEd+mdDUXELhntw9G6Ce/BTT8bN7QQgKuYvV347v6PglN/Faz32FQr+wMwA7lG3GWLFXMwTQ2O9g84dyna+hiOwcmTMKATiHCaqVYEzA7l5GntDvdSceqz+0JRtpmIShk5VWsBd/RWmfzdczMIQfSaBtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863603; c=relaxed/simple;
	bh=cN6C8charlXIxIHvfz4L0XceiAypmdBBCLB3zTOSP7I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NWtn+knwSIah4exujSiEMIbfFQtluMDP0ZNIgFzHgKccnILgxVJKGHrLqTUlI9f704G/bwLSsJimh09SWu7ShYF+JwVnGOsZKg/DOnsdK5MQlWHCuEhY31bpj6gD8LazkHyTjicp4qLcYTRkk7zRA8T+Z02frBGlmr+aLgt+p8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Ys8mu+vs; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Ys8mu+vs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=cN6C8charlXIxIHvfz4L0XceiAypmdBBCLB3zTOSP7I=;
	t=1790863601; x=1792073201; b=Ys8mu+vsx7FDV7vAwxW0OsLLnC8H66tPiHBJJDO4IPhWrws
	VNgHnfYgEbk5kZMbXLah4mdCF3MUYN0AGDgIcAWOu8r4ARQSZi0Zt/yd1rejFcw6CwgFD8AJfVg0V
	yVKh6c8kbO23gp+Cv/oQzYgHOQ9yoNRCH6NTnz5OT1WJ1BNFoSRczGRyLsmciR9xXv/Qw5H3528S0
	t86EnAhUeH8TTYqC1fUr42Fd9YhWSBTECFGbr0R6XZOhcvRLKM51TN/Q5V3iN4aBWCeUDCplM06V3
	1mItMFcVEP1D7GhkUCSbydwScTNA6BBUEGvzGttD4zFk+eAZ/o8hcx3IJMv8UlKA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCHQh-00000000AfF-0oXW;
	Thu, 01 Oct 2026 16:06:35 +0200
Message-ID: <5cb9e89db758fd3af22d3a168a93406fef82c5c2.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/5] wifi: add opt-in FIPS exception for iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: davem@davemloft.net, emmanuel.grumbach@intel.com, 
	herbert@gondor.apana.org.au, ilan.peer@intel.com,
 linux-crypto@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, 	miriam.rachel.korenblit@intel.com
Date: Thu, 01 Oct 2026 16:06:34 +0200
In-Reply-To: <20261001130853.137567-1-jtornosm@redhat.com>
References: 
	<47ebbd91b4bdb57723be40608349eff9ced1f34b.camel@sipsolutions.net>
	 <20261001130853.137567-1-jtornosm@redhat.com>
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

> Based on the discussion around v1, I tried to prepare a more complete
> proposal addressing the concerns raised there (AddBA, CSA, robust
> action frames). I understand I may have gone too broad and missed
> some aspects of how encryption offload works internally, without
> access to firmware documentation it is difficult to get everything
> right.

I don't think that's necessarily it.

> Just to clarify a few points, WoWLAN was intentionally kept disabled
> in the patches (both mvm and mld paths), precisely because it requires
> all traffic via firmware crypto during suspend.

Yes, it does remain disabled, but then (for example) why allow
set_rekey_offload() to go through - it's clearly not necessary.

> IGTK handling was not
> changed either, as mac80211 already handles it in software. A-MSDUs
> are not directly MFP-related, fair point, but they were part of the
> same commit being reverted, because patch 2 and patch 3 are just
> reverting some parts of the FIPS disabling to try to get it working
> again under the exception.

But again, what are you actually trying to achieve?

If you want big A-MSDUs, then you need hardware crypto, which you allow
now, which would seem to _completely_ defeat the purpose of FIPS here
(to protect data, if you read it charitably vs. just saying it's for
paper-pushing).

OTOH, why does IGTK matter so much to you? That particular key has no
relation to data protection, so arguably *that* could still be
offloaded. But you're doing it all precisely the other way around.

Hence - again - my request for you spelling out what you're actually
trying to achieve, rather than throwing random code at me.

> Patch 2: In v1, I only re-enabled MFP_CAPABLE without passing keys
> to firmware, the result was connection but no data traffic. That is
> why I added key delivery in v2. Is it possible to keep software
> crypto for data while having a functional connection, or does the
> firmware require keys installed to pass frames? This would help me
> understand the correct approach.

Well, it does work without MFP, so fundamentally the firmware can pass
data without having keys?

> Patch 3: I can narrow this to the minimum needed. Some features
> (EHT, 6GHz) depend on MFP so I included them, but I agree it
> could be more selective.

That's not the point - the point is that there are different
dependencies and you didn't think about _why_ something is disabled. Not
all of this is all related to MFP.

> Patch 4: The intent was host-side crypto for management frames via
> SW_MGMT_TX (same mechanism as ath9k, rtw89, etc.), but I understand
> this depends on how patch 2 is resolved.

But again, the way you did that doesn't make any sense.

> Ultimately, I just want to fix a problem affecting our customers who
> are interested in keeping WiFi working, accepting that some lower-level
> management frames are not FIPS-compliant while the important part for
> them, data encryption, is.

Which is the opposite of what you actually did.

> I don't want to bother you with more patches without guidance. I can
> try to engage Intel on this, but any help, recommendation on the right
> approach to try to solve this in some way would be appreciated.

I really do think it starts with spelling out what you (or your
customers) actually want, and what trade-offs wrt. FIPS you're willing
to accept.

johannes
