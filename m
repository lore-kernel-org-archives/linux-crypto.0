Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8FA33A6E2
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777396540; cv=pass; b=njB3CCwTHFlX0Vak6MuJPada+RVikwbCuvimW8Rd5j+kX7pbGo7vLMwzTx1/bCGfbbvmekVl8e+16gwQmQEIhcc6y3TBMjFprgRWQyFVTArcZyqlSuB5p0G/4EapoHLDMIBw84/uxf/YfdQLNTEP92xuB4wYt4glKG5nyrS6njQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777396540; c=relaxed/simple;
	bh=Y4SInoJ+gQjLv2MpP5+ds4DYPfajGSs/Ku9vQ9VWKjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UGBGaFdcl/gw08Bz25GspgVuFvvZCqQmSVDhVO2eA0IVJYPqGSrSfb4XjBDWNlP6nYINoIOhaFGIP4zgTU+PFiuacK0CmPB1MuZ79Ukn/q9M0uDgpRz7WPBiEMzFnopubztpDC1oHCE0OT50GIx38hQdAdEDwlWa6Ge8mYCW4A0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KX0pWs0E; arc=pass smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KX0pWs0E"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2bdcf5970cdso65226eec.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 10:15:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777396536; cv=none;
        d=google.com; s=arc-20240605;
        b=J2Iq21JWvyJqlThPnzEEIQMOyyaqMfJoNytQlHOdbZp2UapEX2UClpR2ANAbqabvxx
         7lR+MlRNN6ZNfPFguN70zhj5EpBDwASd1vNcwZxVG5okRkH9oa3XKgKgCjMFQuItHVwd
         NTpudsAJQrdp8pp10MnbryI9invAacgAOV52DeUPYl5cycTUMsyYyAuSq0rZ8JMfKj8P
         IbrSU78PEofpgwPinNQI0yaIW8UAWp0DNhr+Ng85C1qSmuVsNWA+1YsbP1BSentLeDL9
         PHDEG0dlwnZ88MitBbGVuY7oW6taI7+LJ+FnN+bBmr3PJk1pDnjjPhKCKBDc/1TEQ8Jd
         vtHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4mHkN2xwVkuWH/B1Z4Hbwt0I5/IXNGH1RdG0Zb8nsFM=;
        fh=4Gb12TCGke7ilbhQdC5TaFVdyW0du5EDsO4sZWhna1Y=;
        b=Mq09TjOsWnVD0PSxw46fea1cqGaG9A4RXb/Yb20C5rnfx9mXCvxBZEzHnJcqgfErPW
         9SnGjYVcaMkGQXVJPLBFhb9hEsaSgRXVz2JgMl48Sk/+uDLp92MRxjGMgr4l7Y9CC66P
         KC4jO9UTgGB+w1sAvgXNDCkU/s7coQXnhUD7dKvqtfjxl7MwkAuBpcnVyLlKm9jZLJ2F
         8XPfn7+mDI4ulMwe6bf4dvUf9Bq1wqxkecTLL3tTHOECVlm4l0Z6Qena4b7OTq2OLrjK
         hy7g/QNkM6C5wf1GSOW5cXM23Y8gFq0teM1Qf90ndGujrSL6o/1yABb7vwqLzh8h3/He
         pFOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777396536; x=1778001336; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mHkN2xwVkuWH/B1Z4Hbwt0I5/IXNGH1RdG0Zb8nsFM=;
        b=KX0pWs0E79cOegLOBsHlIxrr/RczNRJeTALWToKti1T+ClE4VmEJm5XvQvla2Fpk+i
         QAMatUs63Eye3CwEPJoUBjcgLFLoOrZJjGe4xBHE78FCozCCatKygev6OrYlvY77X/x2
         jHSsgQwL7YukzyE6CZLRfnzwprWLBrdm+5ZO76B7GT2xArHMvrJAwd96XgP/N2fL3Qiy
         h8RVlnWdoJnauY/WTrxYAV1DY4F7rx8tVzP3C8Aa5AO2shFf3cBJhFqTpRLePKdCx6ar
         4uLOU6gCho6Zs3HVtwOigBYaj5KImMKUB4MD9UJiGmIRzJnpj07bPhAZzBccu/87+e3U
         TWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777396536; x=1778001336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4mHkN2xwVkuWH/B1Z4Hbwt0I5/IXNGH1RdG0Zb8nsFM=;
        b=fFnuM1Q8E4bKhgKedjfLLA5QX1K6ukRdwkzwWobbcsvq2Fuu1L9e3L1yj4MYXqUhv2
         uYmATOFj/2s9ytXabuuDVI6v6jNCHp+gHt97dI25lMVJlUsFmucUhCB8ZvIr0RwKr8qJ
         UpX16HgmAHCAc3wOAHarwaIJOwJjv5PxzA4H3ceMp5jTjtgIIXpMlxttJOMbwh7FWBRH
         HwowbA9Dh2hPuR0YXlIeeGPTQKAbJ39XC1qTKh6xUUK4Sm5eZebJnN7Nhvo7n+avTWNd
         aE+CdEhqA6hMpyIKVOS93nn99lDfNjE+BoST4FvL+G5Hia3SkvEnYxWU84GF2dqeSJpa
         T/tQ==
X-Forwarded-Encrypted: i=1; AFNElJ/MY5L9vvMRDvjVOW7zWeJkW6iPlXbD6vK8gyWcamiJsFVlxvc5z9T7xzqxAnP9ax8c6gZkJfQ3vb6vID0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnLEoiMJe6a1OzdgI9USg/TA+4rbxMpHnkfmhNma/EhcTpjjzB
	a/rttTQR0Bev+bYh56zgNnRLhrquQy4pKfmT9JS4Hz/eXTY5RQ7Yh1IWxeR7qSHyJF0IldJcaQp
	uq84g+bdHdHPAS1U+ATxQZtb3f8pJi04=
X-Gm-Gg: AeBDieuMyU185TugH7yaH+RuFCc+Isx6lGxCCPxK5u/4QIPuc99Zi9UfZLKMgH3OhhO
	Bg7KjWT5C+WiSm04nLr1Let89fKGi35qUypN+7kGKPyKJYFUShGJIxQyXu4Iv1okIgNVbHk+uHm
	BD+iE8Z4vfh7OtoqN8jsps+27cqWGLy9tcVbuOjhHaSVF7hB35B0tAC2Md4ysde3BDNf+dc1Hyk
	mvXfWijs+VzJHblty36kzGRLdpPz2TuzRj9m9sU4Lfs9Hp+krFopuZ8qkFOWrN0Sr12RX324yak
	TK9FaCBVXbFXOHna
X-Received: by 2002:a05:7300:cd8d:b0:2e7:190:41d6 with SMTP id
 5a478bee46e88-2ed0e2e4725mr1026663eec.2.1777396535792; Tue, 28 Apr 2026
 10:15:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428024400.123337-1-ebiggers@kernel.org>
In-Reply-To: <20260428024400.123337-1-ebiggers@kernel.org>
From: Marc Dionne <marc.c.dionne@gmail.com>
Date: Tue, 28 Apr 2026 14:15:23 -0300
X-Gm-Features: AVHnY4K6RjnbJfMAlZVpH30RZ8jL2Td5aRSXV2MW-u6vf0Qmr0Jq_0ZDVqUO6Dk
Message-ID: <CAB9dFdtCXMaavBB=NODcG5su8oTqgpYysSJ60bOj0Qivw1dG1Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] Consolidate FCrypt and PCBC code into net/rxrpc/
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org, 
	David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 11:47=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> [This series applies to v7.1-rc1 and is intended to be taken via
> net-next.  Patches 4-5 could be left for later if desired.]
>
> The FCrypt "block cipher" and the PCBC mode of operation are obsolete
> and insecure.  Since their only user is net/rxrpc/, they belong there,
> not in the crypto API.
>
> Therefore, this series removes these algorithms from the crypto API and
> replaces them with local implementations in net/rxrpc/.
>
> The local implementations are simpler too, as they avoid the crypto API
> boilerplate.
>
> I don't know how to test all the code in net/rxrpc/, but everything
> should still work.  I added a KUnit test for the crypto functions.

Giving this is a spin with afs, I get this oops during xfstests generic/011=
:

[   22.838773] kernel BUG at net/core/skbuff.c:2295!
[   22.843470] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[   22.850243] CPU: 4 UID: 0 PID: 5869 Comm: fsstress Not tainted
7.1.0-rc1.kafs+ #89 PREEMPT(full)
[   22.853205] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.17.0-10.fc44 06/10/2025
[   22.855185] RIP: 0010:pskb_expand_head+0x2d2/0x380
...
[   22.867340] Call Trace:
[   22.867617]  <TASK>
[   22.869409]  __pskb_pull_tail+0x67/0x510
[   22.870719]  rxkad_verify_packet+0x297/0x3b0 [rxrpc]
[   22.872550]  rxrpc_recvmsg_data+0x150/0x760 [rxrpc]
[   22.875923]  rxrpc_kernel_recv_data+0x75/0x230 [rxrpc]
[   22.878500]  afs_extract_data+0x65/0x250 [kafs]
[   22.880238]  yfs_deliver_fs_fetch_data64+0x209/0x2f0 [kafs]
[   22.882017]  afs_deliver_to_call+0x60/0x5a0 [kafs]
[   22.882346]  afs_wait_for_call_to_complete+0x133/0x1f0 [kafs]
[   22.883019]  ? __pfx_default_wake_function+0x10/0x10
[   22.883445]  ? afs_wait_for_operation+0x2c/0x1c0 [kafs]
[   22.883878]  afs_wait_for_operation+0x9f/0x1c0 [kafs]
[   22.884342]  afs_do_sync_operation+0x1a/0x30 [kafs]
[   22.884632]  netfs_unbuffered_read_iter_locked+0x30f/0x6c0 [netfs]
[   22.884980]  netfs_unbuffered_read_iter+0x56/0x80 [netfs]
[   22.885266]  vfs_read+0x2e1/0x410

From the stack this looks like a direct IO read, where the skb passed
to skb_linearize() trips on BUG_ON(skb_shared(skb)) in
pskb_expand_head.

Marc
