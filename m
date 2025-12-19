Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C7F34DCCF
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 17:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167144; cv=none; b=BxrVDjiTDvQJZlGu7SAWAdMwPN7dCNBcdZVf4DUQDjRFfB4ImRtodV2hRgbU5B7VvL8Pval7nUpX9Okh7giUbEZHvlQB/vW6MfPSZtufqQOtfucrU8bQ9/QqkwN18kobwi2FW54V1lXFNq1B4DBO98MvMxq9MzR402XOc/AHO9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167144; c=relaxed/simple;
	bh=g6e5vO3Ol6xH4S7OwTdr47jQSD8ZjoSjhs59FF6GB1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UejGCsBU4RP9VqIxlKrg7IfWWq2jbI9a3guEy1tvhNnDArjN02SD9lTqF6jVJVqmUR/Vgcwo5eG5nNEPy9JqeZ76TSMgCanwBZImvWhZLQEzrQJOlZcrNQ8AWUavoZ90leVIDdzk6qHIoXTEtWP1xqC7SuMaHtISqdkv69X75ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bK1fyKuT; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bK1fyKuT"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29f0f875bc5so27424395ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 09:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766167142; x=1766771942; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0SrPRMaOIzE2u2mIWhrjhMSthaxjCZ0sRa3KJCq5ZA=;
        b=bK1fyKuT/5fTMMEKMtDEO+0doolNO6jO0bYGJS0zrzFbSX9/0ryY8lYFME4RhMoxCq
         7SSqVotnWdjl6YltAp9u/BWqLA3Sl/c0JwxH+dLPhRPCj/FSkezdhPf7t4gypJzcxtmN
         P9b1LhUGhwdq3xNnPr81zrRvnUvG1o+7iRJRwlVGFe13gJslYyQDfBCe0fLzicyfRLEu
         xkhsAA9mdlLi7ynaxJ/RJrtBcuTIkttO7Pn0LzqXFFnJeNTBG+rRRVyQO1X1Cpghc4Pi
         YKbizyMvJZx9mctbgMQ5/7FWiXqFaBFSy9iE/RFJ0xd/U39AaM/mbGu5PhI+37ACta5q
         xydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766167142; x=1766771942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u0SrPRMaOIzE2u2mIWhrjhMSthaxjCZ0sRa3KJCq5ZA=;
        b=oSWj3AkEEYIDLz6XngFd8Qm2s8ydFm0eAuhgS4IaXSmJqe12FZZ6jw7obsGoM9Phwr
         7RwmPOH7ChbJn2iOh7a5lMmej8jqcfjzvAB+6dXyfBj35UaeaQdtQHCkIRWHgFCt7PbE
         WuZYPCGqHCtSTz6NwnLHzMN3EhQonKQEIcHw64ATIYhiv1nRHMsExbQqI2FyvMt/Qjvy
         0o3Z6WV1P8VgUyA5kKpd4HBNKJy2c61ru3frhBWMijbOmm8gtIGqmnMVob0ZAfU0vsY3
         Y5AgjJp/U9kjq9+s2AUOasrup6/UNwhCb/O2wTCIKCzm6sohNhf0GN5crmi9O2uGzG77
         RlsA==
X-Gm-Message-State: AOJu0YyHVUOFxYZdG5VqKutJoeMSSrONbq8Xy2euLpxYfXNrJhfaURJd
	+yw7UaNBniOUYRqwGW1/dTAV2dZDhQruChqFW1lUZywo2XIQMh7WOvNwb/QGCGpx4cskVR/sE5C
	5IlFC0M9/7K2ZW64Hk0mJcG6vmtzrfjuTqRq5
X-Gm-Gg: AY/fxX54z385XRZfdNgyvAUErI5CIy/3rS8c3FztXt5FLU9Q7aaSgPi7pNax+Op/CtR
	CD+iEQwnooa2U4RP7iwjb/xgBJgYv1wjc3mQuYaLEOyUsomkmSE240nnVHF7L00w5r1KhFxVw1t
	eFfOuCBbMuhXl8mM7wHcMS1Adc+3zKGBBW9llSTeGGKaEh5VoQah+AtZv7PQZUzKwoHrXrAcPDZ
	7yH8LTjHLOAZn7DVZHqAjPITVuPi7xJaTKQiYM/uSnZukoMEsIWfAGV9F47HfY3zn+54EEWYQ==
X-Google-Smtp-Source: AGHT+IEGTW4Un42sEOUQW5rzx9g4YxKHsKk2uzJ3W427EJTH3C8Q3LOJhJlhNBUsIBobZvQm+nmnvErufF/NbV5LOso=
X-Received: by 2002:a17:903:234a:b0:298:3aa6:c03d with SMTP id
 d9443c01a7336-2a2f2a3fc97mr35245265ad.57.1766167141887; Fri, 19 Dec 2025
 09:59:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3c52d1ab5bf6f591c4cc04061e6d35b8830599fd.1765748549.git.lucien.xin@gmail.com>
 <aUJKjXoro9erJgSG@gondor.apana.org.au>
In-Reply-To: <aUJKjXoro9erJgSG@gondor.apana.org.au>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 19 Dec 2025 12:58:49 -0500
X-Gm-Features: AQt7F2rqKcdPJzSFmWioHHZiw_XeUv_vpki8sDJT0B1YtHiHqhTXpOeTkQzXc4k
Message-ID: <CADvbK_e1b1uF9izfeV3KOuEOckCBXnFKL4NRjb3ZGHih7F89hA@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: seqiv - Do not use req->iv after crypto_aead_encrypt
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"David S . Miller" <davem@davemloft.net>, Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 1:15=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Sun, Dec 14, 2025 at 04:42:29PM -0500, Xin Long wrote:
> > Xiumei reported a UAF crash when intel_qat is used in ipsec:
> >
> > [] BUG: KASAN: slab-use-after-free in seqiv_aead_encrypt+0x81a/0x8f0
> > [] Call Trace:
> > []  <TASK>
> > []  seqiv_aead_encrypt+0x81a/0x8f0
> > []  esp_output_tail+0x706/0x1be0 [esp4]
> > []  esp_output+0x4bb/0x9bb [esp4]
> > []  xfrm_output_one+0xbac/0x10d0
> > []  xfrm_output_resume+0x11e/0xc30
> > []  xfrm4_output+0x109/0x460
> > []  __ip_queue_xmit+0xc51/0x17f0
> > []  __tcp_transmit_skb+0x2555/0x3240
> > []  tcp_write_xmit+0x88f/0x3df0
> > []  __tcp_push_pending_frames+0x94/0x320
> > []  tcp_rcv_established+0x79f/0x3540
> > []  tcp_v4_do_rcv+0x4ae/0x8a0
> > []  __release_sock+0x29b/0x3b0
> > []  release_sock+0x53/0x1d0
> > []  tcp_sendmsg+0x35/0x40
> >
> > [] Allocated by task 7455:
> > []  esp_output_tail+0x151/0x1be0 [esp4]
> > []  esp_output+0x4bb/0x9bb [esp4]
> > []  xfrm_output_one+0xbac/0x10d0
> > []  xfrm_output_resume+0x11e/0xc30
> > []  xfrm4_output+0x109/0x460
> > []  __ip_queue_xmit+0xc51/0x17f0
> > []  __tcp_transmit_skb+0x2555/0x3240
> > []  tcp_write_xmit+0x88f/0x3df0
> > []  __tcp_push_pending_frames+0x94/0x320
> > []  tcp_rcv_established+0x79f/0x3540
> > []  tcp_v4_do_rcv+0x4ae/0x8a0
> > []  __release_sock+0x29b/0x3b0
> > []  release_sock+0x53/0x1d0
> > []  tcp_sendmsg+0x35/0x40
> >
> > [] Freed by task 0:
> > []  kfree+0x1d5/0x640
> > []  esp_output_done+0x43d/0x870 [esp4]
> > []  qat_alg_callback+0x83/0xc0 [intel_qat]
> > []  adf_ring_response_handler+0x377/0x7f0 [intel_qat]
> > []  adf_response_handler+0x66/0x170 [intel_qat]
> > []  tasklet_action_common+0x2c9/0x460
> > []  handle_softirqs+0x1fd/0x860
> > []  __irq_exit_rcu+0xfd/0x250
> > []  irq_exit_rcu+0xe/0x30
> > []  common_interrupt+0xbc/0xe0
> > []  asm_common_interrupt+0x26/0x40
> >
> > The req allocated in esp_output_tail() may complete asynchronously when
> > crypto_aead_encrypt() returns -EINPROGRESS or -EBUSY. In this case, the
> > req can be freed in qat_alg_callback() via esp_output_done(), yet
> > seqiv_aead_encrypt() still accesses req->iv after the encrypt call
> > returns:
> >
> >   if (unlikely(info !=3D req->iv))
> >
> > There is no guarantee that req remains valid after an asynchronous
> > submission, and this access will result in this use-after-free.
> >
> > Fix this by checking req->iv only when the encryption completes
> > synchronously, and skipping the check for -EINPROGRESS/-EBUSY returns.
> >
> > Fixes: 856e3f4092cf ("crypto: seqiv - Add support for new AEAD interfac=
e")
> > Reported-by: Xiumei Mu <xmu@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  crypto/seqiv.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
>
> Thanks for catching this! I'd prefer not using req->iv at all
> though, something like:
>
> ---8<---
> As soon as crypto_aead_encrypt is called, the underlying request
> may be freed by an asynchronous completion.  Thus dereferencing
> req->iv after it returns is invalid.
>
> Instead of checking req->iv against info, create a new variable
> unaligned_info and use it for that purpose instead.
>
> Fixes: 0a270321dbf9 ("[CRYPTO] seqiv: Add Sequence Number IV Generator")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Reported-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
Hi, Herbert,

Which upstream git repo will this patch be applied to?

Thanks.
