Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fQjRHmY5"
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38076F2
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 12:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=dxveFagBNj5/ty55lDPJPyZWurWMS/8ve7eeXES38tY=;
	t=1701461074; x=1702670674; b=fQjRHmY55FQ0y5++oc7gX3SbqbIeYIr57eRzHqXWxx/Auj8
	CU2GP2cC87NUSO75aZBESr8Xpz0aW2SMxtOL1peqOcNwVC0lYW8LVhqTT4oFj9CCg+VSCFs9y4tVn
	3UT9C53TnTGvAAADzjAgD2unG82TlgnxqwdPxRxUw24SWxuEbl7WEVKF11nBcAfGNn67fcm4aD+gN
	uVxK9NasihFAMs7XIXO+vzUpg3x2O6YCcxYyK9lP+s+ngXOPygy5IeVMH9WaUhliDyk5mDCH3844X
	nTi0olAcwH93E7rLJ6sYubX4hiO86Q9PXvyqUa/tp/Ra5fxmPFCytd1dLehsZYyA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1r99kV-0000000BRhY-1WHh;
	Fri, 01 Dec 2023 21:04:31 +0100
Message-ID: <640c12810b336aa99584697e21215f3cacb13c79.camel@sipsolutions.net>
Subject: Re: jitterentropy vs. simulation
From: Johannes Berg <johannes@sipsolutions.net>
To: Simo Sorce <simo@redhat.com>, Anton Ivanov
 <anton.ivanov@kot-begemot.co.uk>,  linux-um@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, Stephan =?ISO-8859-1?Q?M=FCller?=
	 <smueller@chronox.de>
Date: Fri, 01 Dec 2023 21:04:30 +0100
In-Reply-To: <e1b3ccb744d67e6214cf206ba8480cb3e35694cf.camel@redhat.com>
References: 
	<e4800de3138d3987d9f3c68310fcd9f3abc7a366.camel@sipsolutions.net>
	 <7db861e3-60e4-0ed4-9b28-25a89069a9db@kot-begemot.co.uk>
	 <8ddb48606cebe4e404d17a627138aa5c5af6dccd.camel@sipsolutions.net>
	 <e1b3ccb744d67e6214cf206ba8480cb3e35694cf.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2023-12-01 at 14:25 -0500, Simo Sorce wrote:
>=20
> Doesn't this imply the simulation is not complete

Kind of?

>  and you need to add
> clock jitter for the simulation to be more useful?
>=20

No, it's more _intentionally_ incomplete. This works fine in normal
ARCH=3Dum, but with time-travel variants we have more of a discrete event-
based simulation, to integrates well with other things (e.g. SystemC or
similar based device simulations). So this is quite intentional, and
yes, it breaks in a few spots such as this one.

johannes
