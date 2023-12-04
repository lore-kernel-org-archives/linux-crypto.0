Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="WROvKzdy";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="Wox73u9Y"
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.161])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559BCCC
	for <linux-crypto@vger.kernel.org>; Mon,  4 Dec 2023 02:35:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1701686153; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Iuxyr47FgIPs02ssKk4KoI7TW3FM27FlCpHhlLwFOTE1VqovOvMCRxgpl+L8YLtXDD
    WZN4kw1xVbENqT27dTU3J52ugv5m9y15/VwgyPHDITCgOMp1j+1V7jx1HLK0duNUurd2
    gSC3DFIoHvXktfkfkv2D/oOwcFrz22ABQ11o7tEXS34IjweOnbJVx1yk90+xlk4PvKrG
    9lm5BVGmY/JKmQ5yirpD+JvBK6yUyoWggYUzOaCgF4PcHN9T1sPIu58RL/oxVP2coBrE
    1uF0cfesdN59FsPqhvCUYXGc914NNDh/fcQQFS1h2vZ3umluTC9C1GWnL7EUKPGAsUDH
    snFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1701686153;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=nW8Z5m5bh3cNM81N3rj+G3+VMFppcIIbSZzfhji3ATs=;
    b=rshiPZfXhh3eH/73OMxP2RhFuybOA7fLv10ZoVUmOPCc5ETHK5kxCySFR0Dut0h8hU
    JNSw/vFJxZrljrODTSza/0QbSOnKEg1Oi6NbTzfqAyDdKIxnSCC4kW0XSAmQeWLc38XP
    JB/b2rdZCJxIxyv47G5e+uKj7vAZ6hciMHGncXqO6G7BoatgOV/hPojhvXizt+E5vpmn
    p2RS2EqerwvHZ3awUo47fuqqfbfdW2lBD8smlkLZG28beXgpVBvwlSiTdiHeiwJjsFRX
    t6CfmVsPxIbLXygd8wNkUuopFfzCzIwYyBsCzPAntmjnPQxITDrQrbpX/h8RejR7jJWb
    oMaA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1701686153;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=nW8Z5m5bh3cNM81N3rj+G3+VMFppcIIbSZzfhji3ATs=;
    b=WROvKzdyHgLUT/cipqxBF4ePHvD3cUqpgCR+HOgSaA5iLpK+9N1QxmaX8aqf7uVNnc
    t5MEiUX5ERg8Kx2BdqexrtRB8QdaJ0r12PTEUC+BuTntXU9G8lxdzuS8y6G0Mspg2JHX
    Sb0CWV963UFfKTYRGG2YU8PLXVuWEz17njvJ3P1/27f61YyEcS9fGGeoY37jqNcPSteV
    UBP1jZuMjfJhPgOSxljbZj6sw5fDFMjXtWC/vOEu79LWipAodOov/XQroXjfTCqpEBdX
    smfl8lpbGRiLXarkSIZuSDYfs5wPrOjLUPKMihFpZRyJaEgTr/mu+Uf80YRR891kowi3
    5mjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1701686153;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=nW8Z5m5bh3cNM81N3rj+G3+VMFppcIIbSZzfhji3ATs=;
    b=Wox73u9YXVdc8sWAeXgg4d+4VoxjXn50JCpiGZ59WaRJh/fdtQaE7tHkA4kd80K60v
    UtaRwj4FFSD16d7EADAQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDz0d0u1qzE="
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 49.9.7 AUTH)
    with ESMTPSA id jc800bzB4AZqHS3
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 4 Dec 2023 11:35:52 +0100 (CET)
From: Stephan Mueller <smueller@chronox.de>
To: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>,
 linux-um@lists.infradead.org, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-crypto@vger.kernel.org
Subject: Re: jitterentropy vs. simulation
Date: Mon, 04 Dec 2023 11:35:52 +0100
Message-ID: <4603694.2J7E7teO9M@tauon.chronox.de>
In-Reply-To: <e863c5fd47d6b4c36a8f4554d4470ad92e51abea.camel@sipsolutions.net>
References:
 <e4800de3138d3987d9f3c68310fcd9f3abc7a366.camel@sipsolutions.net>
 <1947100.kdQGY1vKdC@tauon.chronox.de>
 <e863c5fd47d6b4c36a8f4554d4470ad92e51abea.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Montag, 4. Dezember 2023, 11:24:25 CET schrieb Johannes Berg:

Hi Johannes,

> 
> Well it _looks_ like it might be possible to get rid of it (see above),
> however, what I was really thinking is that jitter RNG might detect that
> it doesn't actually get any reasonable data and eventually give up,
> rather than looping indefinitely? It seems that might be useful more
> generally too?

Agreed. Let me have a close look at the patch then.

Thanks.

Ciao
Stephan


