Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0113331A575
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 04:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783052853; cv=pass; b=AjaaoAF/BA3UJcsTkeEL13sd+bwsml+lAyNLUWBjsumm6B1+H4U7Gr0TXxNPIbUqNhVHF1hKUegmDXx0kP3uBJr2EDE5JbfhWQ7gEnPVAA7i57oKmrz6jyu1u9JTSyLGeQmKoc7m6NlAZLb3Wi6BdvzWqm1vq+jS/M98gkMXijw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783052853; c=relaxed/simple;
	bh=McgYNujXIHEmyAPzVGLtWe1BDHLYG2tXzy0UienuilM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dPs72prxRD07EMdAXUTQr8pUFOnr9zW4F2DRMTYYOWTg107gSgOppUOwoCLdcWJervwTxawvAnlzgrmnE3Q80MskDFt8j2G41dL6QlVaqAu8kOP/KzF9WWSUN1E4rqOX0mloi8n8e/t2MR1+Iiqqtz/2h1ZQQJMhU8JwjTDWeBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qvv1puPt; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qvv1puPt"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-80a123ef90aso2605037b3.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2026 21:27:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783052843; cv=none;
        d=google.com; s=arc-20260327;
        b=ldu3LDnmFS4tfv5ueE38tlyqJNCti9hIwAnlSunRZiivPS3p9nRmLjwYvZHeJNLiER
         pHA4q6x/nMYZdZ21EYmi7h+sfBcQgebXwVupT2gGXrgXrokHuL/72MZ+eiAXtm5zqj5y
         +uH4noW0H6uB5IjnM4hyueInOW+j3A9hiwZ98/MWtEqYsaK0rej2G8usuMQ7BahEomkd
         PVR3lxgF5S8nAZLUAdds30xDO1U77g09kQXPwUlDEqstyMp9orp+yjbuc6TwziEDDNb9
         cAYXHo5JHf9NEQeevSutLivT33AAamG0d9EHr8VbbVd1qcd/JaX0tTkVsgQmXb6hUnFW
         Huiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MXbn/wf+etNIXYwFRSCKzOQXjhCmxqnBxGB0e1j2DkU=;
        fh=vqfCI+xvgaK42cDAuYE9BHe5FRTg8aJMDV1x4PYGJdg=;
        b=JMrtX2NtX9l24D7syVKRA7/JuO69wV16QGqe/4fNtIcc9Gj78G3RG9VSZ3kJi3HmJt
         kIH8431jihP8YfTIRtmRLHF0qHCWiOpqtv95MOsYpPh2dZxnLRp1CrqeUilT5Expgdah
         j+tdfI8LJwrsxqtLxqYuP/biI5oC/rTk9jFekAgKhHk5N1X86H8ddgwAKpav/aaqUfnv
         734gyCSY/vEaDA+e8qAT4tuIQHvwN4ERtnIVljNc3QB8k/wFeSFGXN4RXW8o/TL8h+Gf
         AHhIO/6Lxy4A5Lps6T+29L2MmsyzcuIYGNu3qKAr2sSp75pPzXzV/enpKDmWCx08BH+k
         rHjA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052843; x=1783657643; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MXbn/wf+etNIXYwFRSCKzOQXjhCmxqnBxGB0e1j2DkU=;
        b=qvv1puPttjKPubA/Jd7XSR65EtvjWyCGWOe/0VLhd/gQs3ozJsliT2EKiDlPYHA9t1
         di7zWm682B0anLEqRigBLlY4CD8alPUBtsumqZqeEyom+D/+TmNjJodWDvMNDLFOKTOJ
         NqYsIu8/HQBiTioGWWx+v/IFIsa8srur6GV+kw5IKnuF7nhri2lUXT0LSiRQyE+Hv0z1
         oyuzjFK+Yie7jy9FZgl3Fr1qz0Rvcycr/UGOYmT+/xv8vGXl1HApDDoLU1ZpgzIfn71d
         pIWPzqk1B00x3LjikpDVuo10OK8elaNkFKjUgHRBWT5SD5T3sA+nZsQWTx+DZL4BnvEF
         /cCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052843; x=1783657643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MXbn/wf+etNIXYwFRSCKzOQXjhCmxqnBxGB0e1j2DkU=;
        b=ftF2a9yXWvSqwlj2oEIdXHOgb18TWy42+/FzQlFV+tRc78YtIySk25Gq4b4kVHkh3A
         patdSh+rXeT51w3S9G+pgjhOZNboOxrSHU9Z8z9XMeJd5fJHxVRhFeERY3j+/CJ36zzM
         BFy+mpH4AL3TyiYy9QErpQa5vgT2RG++raqB0B3d0A6tw0JYdn+InKbACuwNBpOASA10
         dpbdGPLhWzJpdABbRiwZMTRQ1agTeBQ1D1APe2HLu5ob2HTEX6qze8WFWBXuEKUEbzxM
         nKb64wMfL1sFacsXVEsWSYul+zb0PD3w5xNVg3Rt1gso8Tyzauvx9FXjlF1GVVBEjov8
         68mw==
X-Forwarded-Encrypted: i=1; AHgh+RrSizXzMSqapO498vmvKpfTimbMFYcOyyKT2UZjKG8vp51xz1Oyu0bCIvee4EVGr/XouUqAj+3SWOYu7tA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVw4/kK0btxy9Cm0818pjjn+xXkw0Is9l44SL9bkeSGa9+vrra
	7gWJMXTQqbNZwMh3eQE9Lx4k5Cy63u0Gjy/owWmogTFsI0RGLgfQX8UpS4uDNYF1VH+7ziUVVZW
	4VlB9fZUYLe+5itwLpFVHDwkWJ27KBFo=
X-Gm-Gg: AfdE7ck6M7oYLzOaWf+hdv04rnwlAL46LuCeuTojm4Q87IkHAbpW7I831N97n8mkMa+
	J3y0vyQgMa4A/2ilrGQHe7D8SkLkz2x8D4eTxPJ63+EG93ANO+9AQrxy548udpDwlPGINldwaEc
	tfanpfb8RDYC8/gRu6qnA6KHzayI1SvifG1OKcWqYpK+nWEXnTkrAa0DmUa9XNgNdvyuTRJj3jd
	S534obMosCwMuFIQtLT8Q9Q3esmCThBr+SOukCwiY4II4qQk7ZtD3jWSxWzCYy0vE2r9/Tejg+w
	ZfmEj+nzz3Ahy05CgRz0yR3+NTXW7t1cjV/1uQgLcg==
X-Received: by 2002:a05:690c:610a:b0:80a:a005:80f8 with SMTP id
 00721157ae682-815bb67fe04mr22049747b3.26.1783052842985; Thu, 02 Jul 2026
 21:27:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAB8m9Wh559e+=n8z51gB8DrbEyCc2mc0MgGjrRR6_VXBmU=2AQ@mail.gmail.com>
 <akcyUeebmW9AWgLr@gondor.apana.org.au>
In-Reply-To: <akcyUeebmW9AWgLr@gondor.apana.org.au>
From: Cen Zhang <blbllhy@gmail.com>
Date: Fri, 3 Jul 2026 00:27:11 -0400
X-Gm-Features: AVVi8CeZjK5nBGUzzw0i0cwYof9yH1YHnLqEGZ00HLLvDEPYQk4PKgU7YbKYiTs
Message-ID: <CAB8m9Wh7=JWe6djco+eovJbqCyigRWNVWVFxB1GL8FgHLvUzEg@mail.gmail.com>
Subject: Re: [PATCH v2] lib/rhashtable: clear stale iter->p on table restart
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: tgraf@suug.ch, akpm@linux-foundation.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, AutonomousCodeSecurity@microsoft.com, 
	tgopinath@linux.microsoft.com, kys@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

rhashtable_walk_start_check() has two restart paths when resuming a
walk.  When iter->walker.tbl is valid, it re-validates iter->p against
the table and sets iter->p =3D NULL if the object is gone.  When
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

Fixes: 5d240a8936f6 ("rhashtable: improve rhashtable_walk stability
when stop/start used.")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
---
v2: Fix commit subject in Fixes tag

 lib/rhashtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -877,6 +877,7 @@ int rhashtable_walk_start_check(struct
rhashtable_iter *iter)
        if (!iter->walker.tbl) {
                iter->walker.tbl =3D rht_dereference_rcu(ht->tbl, ht);
                iter->slot =3D 0;
                iter->skip =3D 0;
+               iter->p =3D NULL;
                return -EAGAIN;
        }

On Thu, Jul 2, 2026 at 11:54=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, Jul 02, 2026 at 07:25:39PM -0400, Cen Zhang wrote:
> >
> > Fixes: 5d240a8936f6 ("rhashtable: add rhashtable_walk_start_check()")
>
> This commit ID does not have the referrenced Subject.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
