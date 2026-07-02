Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6C4397AE4
	for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2026 23:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783034753; cv=pass; b=iupELQe16kU3sOwnQN/zZxrT1YU/4/0rgf9AkUTS3ZlJGvNLAV8aVRXusUFN8dFzBID5bEUJpJ22uHp/2/DH8HGW3aQnK/z+OUFI22SsQ8ztJaLyeqHr/6n1TVydIhucjvD3cZdsys3Fd26TOKpOs9QFkBC/TWUVH3olS2+7u10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783034753; c=relaxed/simple;
	bh=jBFlTz3g5ssVNguswpHGDgcnemlVnurn+9r1kQA5U3s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kzz1kk8b1LjslkFQeznSoPhIORdLfgsYK02f/oE2dhGrxhTezEAHfByyobDw8ep+xgR6SiPMVtKokX0lWq4b9f4sTrEaq5Kn/On0KXIp5dmiIRKQnZv6OxT+K1HlQrjtAoq1+x8ELSmPrahhcUwDaXpqmyamblDCC7h+5fQkm9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AI72Ce01; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AI72Ce01"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-80814edb536so27793407b3.2
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2026 16:25:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783034750; cv=none;
        d=google.com; s=arc-20260327;
        b=OEu2PQHma/BsD/mFr+thgdl7ey2qPAWa+NnlJNmaFIeOPg1Gdgc41poDypT5zBs5Rk
         mflTUO7k9caxw0geRBcn1bkEt31UUcN4LBdo0eNduOqE0+UbiinidkkFSnIJmxy4osMn
         DqbvTc40s/XNYsj1t3f4piB8RUUmyImgwl+X/qtCfPEse0qwVea0mxk51donulHq9jId
         QNxqk3WdvYQgcCjvEr7H1siyzQYuYJygYiNrpW1HhAdCMsOhAXk414tWGzkUht2WYrnH
         SAx6APLqnT642srD0rnNYsFvXavBanyPsxU/XpIVzrH0iLNd9aSwFFmtYTQUmBozLJLP
         zaRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=rV21b9f1O4/MyL675P4mxep7qc3mbKP7uI9y1dxCBTI=;
        fh=ovY0qJIUChw/rwSe8L59UGFcM+d8tAN6haFGBvlF41Q=;
        b=JI2PXUxnmHE+3dPsEsnrebex0hwkOVGNI4faMUQ9v4bYB9PyvGx4qzRZnntG3GBn6H
         22EOazX5wsczM2n3LMd9jfK0Npt/F+0qap9cPPBEm4DyICtJjrLHb1BL7qZKgOyc9G/Z
         0Ga4wxS1jhga+S+PJoLPHdsEEzNA9yd2/zFumNXlozuE7ufhKrwQP08ifUv3HjYBwJ1G
         w5sbeBOR0qexRmoIHnm/vLVe2t/OytRqimXuiRhLAm6pscnnrbcIZAwYqIlWxjXF2omP
         yqCWGJmBK0GQNMoymlTalm9To/aPq31I13KU2+fdKDF8iQvVlTIpqQzr/q5u62BG6CeD
         fmRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783034750; x=1783639550; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rV21b9f1O4/MyL675P4mxep7qc3mbKP7uI9y1dxCBTI=;
        b=AI72Ce01MLz1dTyigXrPHDBQ+H3Atx3PQA8iWx/3pkK3Tz989Hcs/4wE8TL/OU2XcD
         d4/FERMmoPbFSYLIH7rhTIEbh//3OF+GaG3OMpfOyBgGfD9ANyQFxLTq2mIlBZEd9EP/
         qeqozMqTeijUvvYkKdhi36RR7jIDYqeJPSUg6xAynvNZWi85mh3wvIipSqrbGqo3AdWf
         3Lpm4ovrlbldd9MKg3aE+YtWY1CCiDf8K2GpMqp4eeXCIa19Pfiiwz/LUfI6TMaQtM66
         TXODn85s/RMGeAQHtS0EIDfoyOsQ4iWHk1qVBDzf/I52IwCWWvQCLJLad0mlQn+iWY7t
         glBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783034750; x=1783639550;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rV21b9f1O4/MyL675P4mxep7qc3mbKP7uI9y1dxCBTI=;
        b=BnU9u8BErr1HpJG1ixsEouFYZ4E8bJWQvnaCPEzGU8U3iaPGWg1D+uKqeV5oA3ZeWr
         f383P5slUvFYE7S5Gw+e3xUMqfjRonjX2Lyjh72+bK0ATcT32SXOxHAshYBN41qzF6/g
         Xs30q6hGq0q1jd9T8wGL/LUHvOH3rTdhwvI4E+kwXQHdhHDLUejoZfQRyvO6C+9dIu6N
         cNjxSxqXkSSXex6szifyJH4EEHy4kaqS5uMktBVPf0/76aO8GfWS4P3KRTA5JuEmvnnZ
         P9oq+6zF2XhLHE7ZBwOEK7k3spKqSiL5jjyhedCF/ZS48KSJDb682XcruhULDI1JbTZR
         7DOQ==
X-Gm-Message-State: AOJu0YxhKnt17BG7RDgH8iSblvPMJvfUJHXjToZRaXnBfklR2Dk1p3/M
	z3KVKhWhqEkQ3sLsZR1RzuztRnT5cLc/+TRMSGJxZze/eKI1hj/80TCilApTULwC838RL5DhcrM
	SHlbuQCHNdFutVYsPn/t0n7TAOZJHHyw=
X-Gm-Gg: AfdE7cmx9uXJpkElDA2k+BSjbolKHLUfCoxE1IJSakkilEyDHeX3nHActm3WOmr6Gs+
	m4df4/QmkKNv+ZEB3qSPkO0z7DqAdr9r1Mb9iymiPq83l1OQcAas7RVnlwjvW0Yt9ijc5nC23bj
	AbpvOZjtNGKmDbUqYYGEK/cQlDJZwdK6Ui+qlPZpTHWSiyr84aFPmVQmjqyli5if3EJE9HSbr4R
	jla50ykLVfj6r6NiHYmjDZgEBd80N6dXN9wkHWQYCy1NJ8F0dUKU/wIINSwlcgR9Xq1yDsqpYOH
	IALtVgi8fpJvd2d4w07N/r3io/5JjSqBdsBM7+xV/g==
X-Received: by 2002:a05:690c:7201:b0:7bd:7c16:1711 with SMTP id
 00721157ae682-8138391605cmr80930037b3.22.1783034750258; Thu, 02 Jul 2026
 16:25:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Cen Zhang <blbllhy@gmail.com>
Date: Thu, 2 Jul 2026 19:25:39 -0400
X-Gm-Features: AVVi8CeR71I-euCD7xjaFrXPODeAJrnVqaPU2G_cAszqT4M8lt0djgSGh1a0Mh8
Message-ID: <CAB8m9Wh559e+=n8z51gB8DrbEyCc2mc0MgGjrRR6_VXBmU=2AQ@mail.gmail.com>
Subject: [PATCH] lib/rhashtable: clear stale iter->p on table restart
To: tgraf@suug.ch, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, akpm@linux-foundation.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	AutonomousCodeSecurity@microsoft.com, tgopinath@linux.microsoft.com, 
	kys@microsoft.com, Cen Zhang <blbllhy@gmail.com>
Content-Type: text/plain; charset="UTF-8"

rhashtable_walk_start_check() has two restart paths when resuming a
walk.  When iter->walker.tbl is valid, it re-validates iter->p against
the table and sets iter->p = NULL if the object is gone.  When
iter->walker.tbl is NULL (table was freed during resize), it resets
slot and skip but forgets to clear iter->p.

rhashtable_walk_next() then dereferences the stale iter->p, reading
freed memory.  This is a use-after-free.

Any caller that does multi-fragment rhashtable walks across
walk_stop/walk_start boundaries is affected.  Concrete cases include
netlink_diag (__netlink_diag_dump in net/netlink/diag.c) and TIPC
(tipc_nl_sk_walk in net/tipc/socket.c).

Crash stack (netlink_diag):
  BUG: KASAN: slab-use-after-free in rhashtable_walk_next+0x365/0x3c0
  Read of size 8 at addr ffff88801a9d2438 (freed kmalloc-2k, offset 1080)
  Call Trace:
   rhashtable_walk_next+0x365/0x3c0
   __netlink_diag_dump+0x160/0x760
   netlink_diag_dump+0xc2/0x240
   netlink_dump+0x5bc/0x1270
   netlink_recvmsg+0x7a3/0x980
   sock_recvmsg+0x1bc/0x200
   __sys_recvfrom+0x1d4/0x2c0

Fixes: 5d240a8936f6 ("rhashtable: add rhashtable_walk_start_check()")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
---
 lib/rhashtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -877,6 +877,7 @@ int rhashtable_walk_start_check(struct
rhashtable_iter *iter)
        if (!iter->walker.tbl) {
                iter->walker.tbl = rht_dereference_rcu(ht->tbl, ht);
                iter->slot = 0;
                iter->skip = 0;
+               iter->p = NULL;
                return -EAGAIN;
        }
