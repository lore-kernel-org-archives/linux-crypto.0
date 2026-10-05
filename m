Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D9D3AB288;
	Mon,  5 Oct 2026 20:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233746; cv=none; b=CF/43Tg/B4YArZ8vnmwb/bXdtKq7718NokwjClWsSVAyEingWtBF+4Jv/L5bnwWIbHhX9huVEne9YHywsBqrPUzhlYkdfUKHb4+/XedvQ3smqkPgjFtQp9KdP0RxV32wAYEZsqwR0VTm4ZkidERU81MvI/fgtqMrGCt2ZfQL+w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233746; c=relaxed/simple;
	bh=7ekFXvzem1Gyk0ZXiZZO+Q2FRg+laRcuHg8wg7vBabw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ul3j9HZovVsdz5fn1K9KhG4Fyaii0KxH/6gjxITV9vTI9BIZ18ZTYJe126a/j0eq+PpD8o/IRGORP7MaHCCqQ4fJg0oU5+SNIrw7/m1OY5Wpru3jvCzdfBEExl0lIvSYK4QOIYwr7jS3/IdurEjWSHS7ZOISOUfc41m4ahYzxhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=mljDJI9b; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="mljDJI9b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7ekFXvzem1Gyk0ZXiZZO+Q2FRg+laRcuHg8wg7vBabw=;
	t=1791233744; x=1792443344; b=mljDJI9bzVaR6f5NceNi7URJaBZJApKxTw7qifotuw9bbkG
	8T8GX4G03RS7r9PNel7i7TBnRZWLFPip0OyBJpo8mbZJ/T/3XN++a6A0D6Zmpb9ldhj85Z1UZGDHR
	0jx1cQzOhU0bb2UbijLzDzP6BrHBVbWViVzLnnTj9wL6tl9nKPOJJ1Rb7qqv9tKutpuzspUaTXx5S
	dYzyLjkadGU7Yvd/LtojKfyfsdpFkCjbxrS7Z8j/KWALIwwUL2t/B2xFmpuD0CLN+uiNI4umlB1c0
	Vv0ZXSsOItJGTFnrkSBZhxuKep7I+0ayRDjD2GMzhh6BGpb12guQScue/+RO59tg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpij-00000005dJR-0l0y;
	Mon, 05 Oct 2026 22:55:37 +0200
Message-ID: <289161e6ddaf18fa63a55623c75d700850fd57b6.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/5] wifi: add opt-in FIPS exception for iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: davem@davemloft.net, emmanuel.grumbach@intel.com, 
	herbert@gondor.apana.org.au, ilan.peer@intel.com,
 linux-crypto@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, 	miriam.rachel.korenblit@intel.com
Date: Mon, 05 Oct 2026 22:55:35 +0200
In-Reply-To: <20261005164521.1037345-1-jtornosm@redhat.com>
References: 
	<4ede9873924541b7bed3fc09f5b8c8eb0415ea40.camel@sipsolutions.net>
	 <20261005164521.1037345-1-jtornosm@redhat.com>
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

Hi,

> With the minimum changes on top of the fips_allows() infrastructure
> (patch below), I have bidirectional data working with SW crypto.
> mac80211 handles CCMP encryption/decryption on the host, firmware
> has no data keys.

No keys at all, but yeah.

What are you testing with now? Still MFP?

> However, I had to disable RX AMPDU aggregation to make RX work.
> Without PTK in firmware, firmware does not set the correct bits
> in the Block Ack bitmap, since it cannot validate the received
> frames. The AP assumes frames were not received, retransmits,
> and eventually gives up. TX AMPDU works fine because the AP has
> the keys and sends correct BA back to the STA.

That doesn't really make sense. How can TX A-MPDU work when you have
MFP, this was the bit you disabled earlier even with all the other work?
And the firmware has to send the AddBA request, so that can't make it
through??

> Disabling RX AMPDU forces individual frame ACKs, which work at
> the PHY level without keys. The throughput cost is significant:
> ~12-30 Mbps instead of ~500 Mbps with HW crypto.

That almost seems low (11g maxed out at ~24 Mbps with 54 Mbps PHY rate),
but depends on the channel width and MCS.

> Analyzing the Block Ack protocol, I think the BA bitmap only
> requires the Sequence Number (from the unencrypted MAC header) and
> CRC validation (PHY-level). So neither could require decryption keys.
> Could we allow this behavior?
> Is there a firmware mode where firmware acknowledges all CRC-valid
> frames in the BA regardless of decryption status?

I'd have said it should already work that way.

johannes
