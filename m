Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C0D2E0418
	for <linux-crypto@vger.kernel.org>; Wed, 15 Oct 2025 22:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760567782; cv=none; b=jhit67H8W/gkehtwL6nx7SBylvJPEMoaZ6xdyx8fUzJLdigCgSLei/J42t7sVcmPK2YMo0io8nzPNUg9N0JEvwK0jeAEV1NbYX2U5BKsSPFxI1OCHrIlqHDsZ3OWW0qxGtxzP74kxl3NMfrySAIql6jMynm/dzOqqT36fewRuAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760567782; c=relaxed/simple;
	bh=h+MIKm+w0cbUlpRudhd8wZx6gz8D5s8pBBnEVX+JhjU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JtwszdoMp441PQjpyl41rf3G+asVarpV2NlW+nzHCoaoI7u3pyarC+oA7861S+xeeU2WfgFUFWcMSN/RkVfeAl9/1ZhLHOnxjg7/4qIMkIsFG5Nppl3qhVXpNm/Ggbh/M7D1L0Iri2kWIXwY9yNKJxyh4gRcjQZ6TA0hVzclwzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m/UX29fY; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/UX29fY"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-42f9ba7e70aso402905ab.2
        for <linux-crypto@vger.kernel.org>; Wed, 15 Oct 2025 15:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760567779; x=1761172579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/s3SxkSL7eyHkb5KLXrWbWzbuM7vlN9wwYLs0WQrX4=;
        b=m/UX29fYVdGZExE2N0CbRWUkz/xxLT2F9y1L0UhAckvFNCozrmffx5hTvaqB7uHNGb
         nmYIwabxvsuw7M7Dy4L49XSPzf9Bc2llbD5dtNr+Wm9EGSIn3rvnSGhMR5W/PoV73WaK
         ivV6pzdVxnbQn32sbzhHXZH4Icmchreqf0M21qQgUGnKEJipmRT+gHcwqxfynph0p3Jn
         k/NvURVTyoRCw8ngrloiDw/aP/NtF9rTz8i0haX+yQ/ldR2IO2VB28EcLRHRxn+lR4Ec
         +APZyOCqiueoM7IAS0Pl6jlAuKF+kiE9y8EWxNqygoj48odt9do8BNOrxVcimja/y90l
         0TWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760567779; x=1761172579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y/s3SxkSL7eyHkb5KLXrWbWzbuM7vlN9wwYLs0WQrX4=;
        b=j1DVvoSEL/5y2uNJNSwWvZ2x7TWYzTEcaKXobaD54g86jH/4YoOAgBZ0ifrGV1Gtcu
         mIbJOqVHh8sz5k+cTxgm2rdi8tK3cfrn5q1we4cD8ZRJ6BfmiJBI5G4G7fIJpdLQDhyF
         y9cJODGpEs9kIjFNVXIBjoPRKDUnSs8r2R+mk0RJelHAPOlkn4A+qiVeZjoX23YNAxOR
         kTz1OLBK5c2WwSTNZ58PWxHnu5sdIIKk2llLSZnbu//+jD3+pXi7G61KRjIRM4QRDV/y
         lmYd0+c4CjQF30ajWG2uMrAoa5PTpfkn9gt3R2Z9G60F40y/GsRBar/dE3vAXafQuDYi
         7PQg==
X-Forwarded-Encrypted: i=1; AJvYcCUG+VUB6iKDtFjt0yCT/5fVsrdiKK6erTXCOxvZ9NRP+0FHqGRkcQwy5domnJmZ8Z6OwiJA7IFCMslF8J0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvGl8lsd7cHVGMWeIFpF+1ohvYwgYfvyFpGGla/4eMsA46jnxD
	JlsHrevNV36n/buuJQ/fx5m8EUKcsJRY2SraAev3Crh/5m+VmvaJ3wprtB07nazxQGjBQ8i9k1R
	OBrXdy2M5m61DqEH0BZXdiNBFE7xNJTE=
X-Gm-Gg: ASbGnct/L2hz+94B380Btt9ygU1GiBrJqN0QV6tDkCwpGZOGOeKzQiHh3N5n1HMOM5W
	zCIbCtP/GO2SunBKQMOMOrLdB7swHaGiYBqn17gYckPnFOLA5al8jsHYAJHFPy7i+416/4n3ukj
	0i79enO9MZHCgH/MzWTuVKp7QEcGEtM6abLlCGzUiy2U3SNsCMGPf57fiwOlMTFXlRbOcyAiuOY
	OoNga69qLXKneWvmp/TCjT4ayvL7YI4Aw16igemfVk5+LIB6VFqycjWR+9nmtTSZuNgX7sgaLvl
	9yjVo6dEvTo=
X-Google-Smtp-Source: AGHT+IGtboEau6Bk88v51SDez19PVTOsqLfeOAK8nKqy+9mn8xNBqudys2qDDCtNVqCWa7SL4XVc9GvBu99uBwf86Y4=
X-Received: by 2002:a05:6e02:1c0c:b0:430:aedb:3719 with SMTP id
 e9e14a558f8ab-430aedb37ddmr43372305ab.4.1760567778959; Wed, 15 Oct 2025
 15:36:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com> <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
 <CAKEwX=NyUR6UE0PhXCaHOdta4=gVvRj7QgZtpPaLADpfXYyvZw@mail.gmail.com>
 <PH7PR11MB812102541D5106A6D0E21E28C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAKEwX=NkaaCkoyULr4J+5-F+L5bRhM0F8JsV2DS0Mk=xYhncRw@mail.gmail.com>
 <PH7PR11MB812150A977B6F9F68ACDBCC9C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <wn6pnt2nm5pguceiquctilul6lrk3ckycypwnw2zfxqrlgi2cf@5qn32ewswfl7>
In-Reply-To: <wn6pnt2nm5pguceiquctilul6lrk3ckycypwnw2zfxqrlgi2cf@5qn32ewswfl7>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 15 Oct 2025 15:36:07 -0700
X-Gm-Features: AS18NWBiVKuP96cBHxdACGNu0LbupTKRms6mwcpp7-LPrgrL-Jvm71bteOqHTN8
Message-ID: <CAKEwX=NT_3QJSQGRgogGYmx_M262O+F4Hs9BtbCUqK3qbh+t8g@mail.gmail.com>
Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2025 at 3:24=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Wed, Oct 15, 2025 at 10:15:12PM +0000, Sridhar, Kanchana P wrote:
>
> I am against increasing the size of struct zswap_entry. On x86_64, there
> is a 3 byte hole after 'referenced'. We can technically use that,
> although the node id is usually an int, which is 4 bytes on x86_64.
>
> In practice, I think 2 bytes (i.e. short) should be enough, but it will
> be ugly to cast the node id to a short. We should at least WARN on
> overflow.

Can we pack length and referenced using bit fields? I assume
compressed length cannot exceed 2^31 - 1? :)

So, something along the line of:

struct {
    unsigned int length:31;
    bool referenced:1;
}

That way, we save up another 4 bytes hole, which can be repurposed for
the node's id.

Does that work? I'm not very experienced with this magickery - please
fact check me :)


>
> Or we can take the simple route and drop the bulk allocation.

Or this :)
