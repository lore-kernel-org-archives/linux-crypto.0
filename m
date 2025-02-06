Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A5919C55E;
	Thu,  6 Feb 2025 22:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738880939; cv=none; b=PlOAWrBey7thKM2Zyho0NiYSk9j759qbaE8pUh2lYeCHfMP4rE7DljLh8/jr46zfzsCQVI2TyEns16anyFTL7YotGqtHdcH6ZSdBv2NMqSG/eyCOEcN1R5d8jOmIuY+aq5L1DEGNOS0go0CrW6EP4i1ytIQeIYGOdfHUgCrDTUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738880939; c=relaxed/simple;
	bh=Mx+lQZoBdZSk05cMHd62AFuGqNDVMxjNyfwaalYB3AI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oJBLPqOjE4EhBIBkSRTYticzGZr2iCWjO8Hn2Velbnj4TYT49YpPX2VsY1YiIAbNkXtthGP7+DcGRvQb/6s7Be4IWKrkNhCNoJ7PLBPBMLPgvjHEGnNrNG8RUB0nU3s6F7WhlvpmOqjx2TJTc3BFNQEyr8vU0weXf0ByCOAtjt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QXZ3fdp+; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QXZ3fdp+"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-436341f575fso16876965e9.1;
        Thu, 06 Feb 2025 14:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738880936; x=1739485736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AzyZcVghqPnN4Mo2A4ODdE05nTAFhlmixOy6XL/94ac=;
        b=QXZ3fdp+aF98Lhs7zPuzLQmaE7ERbvtUJE/hwMg9FrCF+eDG6qOmwv2rOwGpmOllAE
         6bVcaFuy8tavH+O2Eo7xebYSMfo2E2YoFQ58iUmFhc3dnZpd50PC+mY+ha2DCyBYENbk
         ov6v7sI2FZsBSZtF7lCpGOelHjfb5hMGEjTkQKsC42kEABcvUh0uc1p25NdPkZViqMN7
         YMpKGRir2soyoQkcLEpEr3qOl+o/T1+GIlZA1NyGTdnC6pPs9dbrC5br6c3DTyH6slHZ
         BOpsFR8bh2bwnNPhhz3FZTuFtFEVs0XnlV5bjwa3Gj5QgzmXqRmjrFnE3V3ktXU8S1ru
         IgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738880936; x=1739485736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AzyZcVghqPnN4Mo2A4ODdE05nTAFhlmixOy6XL/94ac=;
        b=uD1z93ct9bXgDljoWt/5PlQUzf0nRohxxyA/PDqW2nkWN4toNb4Pm+uL4HVyUMtQKp
         KOMbPpw0vuIe9M8YWiUmTZ1EQmZ8XxHrh1Ew2wfo5zhUtlNTYO2cV3+NQKxJ+oMj85+U
         /I4rlVPgeHhi/ET0yepcak+Nyky36mvulmOOD/fy6Lx8DqJ+5AyxwlQoG1A9StYDDbx6
         8p16LUidDGA4hzJ5X0pMtUKQH1nNjoFV15DhjIceCllrXdr8419UYU9IZtsFq0CnTsSs
         poL9+DmQfgHNl2TRQOk1ObaXW0ZkLSTKKxPTbKCw5BTrkaA3935vPVkMyF1pu2DqHFhb
         psjw==
X-Forwarded-Encrypted: i=1; AJvYcCVNBsRpjxGBQsXDa8Coz/A3PHrF2rO9V7UtTI0UiCchi9CHngMrIlg4Ff3xd4tlTsclzKlsrldniqJrTg==@vger.kernel.org, AJvYcCWEKYBarJEBIsHZvAtC/6mPoLdqR+to8Vo4LxX+hhqJHYBce8oa6J6AXpeTpp2yBua9fNqs3IYQqYIwEnmb@vger.kernel.org
X-Gm-Message-State: AOJu0YxmkjkyuC6I3yGt5y0kGablPFA3YNQw+l1T6reOdQEAxufNNxUd
	msrL1g+T/7jkkoc2P7N2tzr8hKi/dELuneCg27n611eaPWBS1oLq
X-Gm-Gg: ASbGnctgy9PtTXYauVEvvrGsulX4D7HNXskvXp1K5pjQMVgaJr/Qj9s4is82NR4aXdC
	cWcFksCepYmtE0uXP+C/y2n9vc4IbHSvDPqFEncfwn8IFu425RFcoVLlP+7gdqQwlN+r3mJ+sHc
	LPuIvad4MBmtlQGj2YI/H25L298j02l6hI9obucn/v5Q4oCudLPgABy6hPFbEcZjKRa0bnHNzt4
	7vYVL3H9gieyHQKtCOR2gBaBvrGRFWdTtxACnGUtGY5b7ZBCWpNZMCizVLzWgkyMqHyixext4dK
	FtCC3ridMzmfQY9dMoqHH64jPny289MaVvQpqbfMofWcooexRD8H8A==
X-Google-Smtp-Source: AGHT+IGeOLZPXsD8/kTcfydH/2F1RNTk+fwe51Rf4ZsVHsczDEc3rlGGaGfvDtqjbHviwX7XGFtOtg==
X-Received: by 2002:a05:600c:1547:b0:434:f5c0:329f with SMTP id 5b1f17b1804b1-439249918aamr12511115e9.14.1738880935750;
        Thu, 06 Feb 2025 14:28:55 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391da9652bsm33244655e9.2.2025.02.06.14.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 14:28:55 -0800 (PST)
Date: Thu, 6 Feb 2025 22:28:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 x86@kernel.org, linux-block@vger.kernel.org, Ard Biesheuvel
 <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>, Kent Overstreet
 <kent.overstreet@linux.dev>, "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 2/6] scripts/gen-crc-consts: add gen-crc-consts.py
Message-ID: <20250206222853.1f9d11c3@pumpkin>
In-Reply-To: <20250206200843.GA1237@sol.localdomain>
References: <20250206073948.181792-1-ebiggers@kernel.org>
	<20250206073948.181792-3-ebiggers@kernel.org>
	<20250206193117.7a9a463c@pumpkin>
	<20250206200843.GA1237@sol.localdomain>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 6 Feb 2025 12:08:43 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> On Thu, Feb 06, 2025 at 07:31:17PM +0000, David Laight wrote:
> > On Wed,  5 Feb 2025 23:39:44 -0800
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >   
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Add a Python script that generates constants for computing the given CRC
> > > variant(s) using x86's pclmulqdq or vpclmulqdq instructions.
> > > 
> > > This is specifically tuned for x86's crc-pclmul-template.S.  However,
> > > other architectures with a 64x64 => 128-bit carryless multiplication
> > > instruction should be able to use the generated constants too.  (Some
> > > tweaks may be warranted based on the exact instructions available on
> > > each arch, so the script may grow an arch argument in the future.)
> > > 
> > > The script also supports generating the tables needed for table-based
> > > CRC computation.  Thus, it can also be used to reproduce the tables like
> > > t10_dif_crc_table[] and crc16_table[] that are currently hardcoded in
> > > the source with no generation script explicitly documented.
> > > 
> > > Python is used rather than C since it enables implementing the CRC math
> > > in the simplest way possible, using arbitrary precision integers.  The
> > > outputs of this script are intended to be checked into the repo, so
> > > Python will continue to not be required to build the kernel, and the
> > > script has been optimized for simplicity rather than performance.  
> > 
> > It might be better to output #defines that just contain array
> > initialisers rather than the definition of the actual array itself.
> > 
> > Then any code that wants the values can include the header and
> > just use the constant data it wants to initialise its own array.
> > 
> > 	David  
> 
> The pclmul constants use structs, not arrays.  Maybe you are asking for the
> script to only generate the struct initializers?

I'd not read the python that closely.

> This suggestion seems a bit more complicated than just having everything in one place.

It'll be in several places anyway since the python file is only going
to generate the lookup tables.

> It would allow
> putting the struct definitions in the CRC-variant-specific files while keeping
> the struct initializers all in one file, so __maybe_unused would no longer need
> to be used on the definitions.  But the actual result would be the same, just
> achieved in what seems like a slightly more difficult way.

It would leave the variable declarations in the file that used them - making
it easier to see what they are.
It also gives the option of minor changes in the variable name/attributes
which might be useful at some point (or some architecture).

I've got some similar tables for a normal byte-lookup crc16 (hdlc).
And for doing the hdlc bit-stuffing and flag/abort detection on
a byte-by-byte basis
The whole lot is 11k - quite a lot of memory inside an fpga!
I started with the 'header' containing the initialised data, but
later changed it to just #define for the initialiser - worked better
that way.

	David


