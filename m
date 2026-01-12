Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7363815C2
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 18:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768241500; cv=none; b=brYyToxzorcPnL1JJB0zHF4x+sAWxPplE1qcdLR2VFauIUTAOR/UQvOysZKn727oa7UdX0rFR4tjZVEGeJaPEfk7Lbbqe5CkSZJPSiFEGHDBfBWmTQ0+val5EemXJuOXtMfA9HsuibZLyaBpcdk+lv63oYa+v3Pna+JGHwTwUGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768241500; c=relaxed/simple;
	bh=fFcP0DbQA2hNBd36x1ltvD0yBLw29jFLbltMBnhdBG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSvewMYI+ep+5tEi8EOr2kpw1YxSoMYKovqoCIQzBGphR966YYG4AHkj/OhwSr/dhmskjtYDcW9UisFdjxOFm3vdl6DLvAUFPro2v4F+sstJNbEZDPoDK6jzO7TkPvgEfsnOi9X53AY9TCHFr4Ly0t2x2ZHR3ZWynEsn6R3OKAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wbinvd.org; spf=pass smtp.mailfrom=wbinvd.org; dkim=pass (2048-bit key) header.d=wbinvd.org header.i=@wbinvd.org header.b=An53TtXx; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wbinvd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wbinvd.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wbinvd.org header.i=@wbinvd.org header.b="An53TtXx"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-11f42e971d6so1544218c88.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 10:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wbinvd.org; s=wbinvd; t=1768241498; x=1768846298; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fskuJNDN7ah1k6MwRaRiHDHSFs0dVGdpVVlIWs6g0AE=;
        b=An53TtXxkgb5i6EB123LyeHoyjioZE0V9rlX5elzlb8Ry0Nw8cRuTppBLsQqAExmv0
         xNbDKVyqhjA0Pc/DtXkNr2/BxKuzQxR3zeCQGcPUIwfjw+sbEZJdVwc7saeTgGrsTt2S
         O/9wl+YM9uJ36BVZqRLUKUcqTLGEtTmzllLfZA8e6llBcSwBwU3xqFpg9AfViZ4cJWaC
         3KkfmLseZsVI99K49YFFfkkmCK99HodYcq/ftMgdK0V+9ErIMF+UZdDqJrjliKMn7KSG
         rpoCccrXTmrcgjsw5Qd5UQB/lcPUnT6NIS2ljhMAiTipQt8xDLG0RTmR4orQ4nrhOytV
         33Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768241498; x=1768846298;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fskuJNDN7ah1k6MwRaRiHDHSFs0dVGdpVVlIWs6g0AE=;
        b=KFnEq6XrKk0JHCLiAFt4ekUmi52rxz/8Ngao3YZdG0ABdmUJlV8m7AqcNG0kT+BiFP
         1dSLB4bfqrQjaX/RB562KCyPVIOV5yqjH8NUNAD1GNbPq+UyAmE0B/1L3HejleCpCH0c
         /fX5xEKv1sy4wZxp681CsWbl7qnO7ITbSWcLAiVo8M+xlGEPryN2vvwizSR91YE+AYt5
         2Dm2O0ryRk6VjtLl0OJ5kF5rYiqjfm/2E4B3awi5BqazSNAQVatEMN0YW0Lrb3uyq6AP
         N5tWisEuQSQdo6q0hMswklb/2w3Kz/g+wx4hj3hd+s+GdE/D4Sl376qCtm2bncByqrKb
         zWbw==
X-Forwarded-Encrypted: i=1; AJvYcCUCn8qZscXwshriFLz2cJr3IIeDKgS/Z2yG+vFPcKlCK/WTOs3PMKvAT7TU9Qyi739Lleai+tXfMckZ5/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqG8e4dX1C8i+Bn9o/HYx3mnW9/IlW87WTyG59WuCISSFUikvS
	o2SEZzbnr6eRkje6k7FP2Ym74l7RIsmObKXCFxDV5UC6Ge0eXcmYSUcjh8rtadiiMs0=
X-Gm-Gg: AY/fxX5H++y5wkXqQWXm6i33ze508OEb7fW1JPgGsZYmgg/aMB9mYsbgbPEkjt1OeDg
	Q/8D4Au0Bu3sk1qqGr0BZGsh2JEuaY0otIYmkvIeFim+fFY4tRUdfyi/D3+4VxsBlc2ZHsAUKqq
	D5N3mvK2jC94iSUz/hK4gBGTsI/MFROW42O83592O5vgzze51J9BW8D0+/pacR61O5psKWXXWO+
	x8+eaoTZhxq+UUQRljjvrp7Z/rFz9ZxSJVLyoZxKZy2XnVZQ0lFEp/UvyW6pJAV2dkbij1JMiyB
	NYqCocL23j+Kf4gkZgfebhX4LAgU9jcjXaTpxi9mVjoCNF9hLaxx/+zmuEAv+As/fswg5bd7s0x
	XQw0EvYSXTKGp2wPK1q/UKVMAfIaEXI4KpliOuHn4fYG8eLJc0L/IyWbUiXJysHkKOtVB0SGQD9
	W7sYzBLLBmYgHeCQ==
X-Google-Smtp-Source: AGHT+IGNt6oDzBfL0zHoJ+UM+BbLyjGJDfL3blbOY9WejiBqLu6Cxhb+pC6rJecCxLZ53cxOs52d3g==
X-Received: by 2002:a05:7022:2207:b0:11a:436c:2d56 with SMTP id a92af1059eb24-121f8ab6931mr16746646c88.2.1768241497522;
        Mon, 12 Jan 2026 10:11:37 -0800 (PST)
Received: from mozart.vkv.me ([2001:5a8:468b:d015:69c1:c5a3:b5b9:6ece])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f243ed62sm25984960c88.5.2026.01.12.10.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 10:11:37 -0800 (PST)
Date: Mon, 12 Jan 2026 10:11:34 -0800
From: Calvin Owens <calvin@wbinvd.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [QUESTION] Debugging some file data corruption
Message-ID: <aWU5VnDW8cHnnauK@mozart.vkv.me>
References: <20251111170142.635908-1-calvin@wbinvd.org>
 <cd54e3a7-d676-46fe-8922-bb97d4e775cc@gmx.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd54e3a7-d676-46fe-8922-bb97d4e775cc@gmx.com>

On Wednesday 11/12 at 07:32 +1030, Qu Wenruo wrote:
> 在 2025/11/12 03:31, Calvin Owens 写道:
> > Hello all,
> > 
> > I'm looking for help debugging some corruption I recently encountered.
> > It happened on 6.17.0, and I'm trying to reproduce it on 6.18-rc. This
> > is not really actionable yet, I'm just looking for advice.
> > 
> > After copying about 10TB of data to a btrfs+luks+mdraid1 across two 18TB
> > drives,
> 
> With LUKS in the middle, it makes any corruption pattern very human
> unreadable.
> 
> I guess it's not really feasible to try to reproduce the problem again since
> it has 10TiB data involved?
> 
> But if you can spend a lot of time waiting for data copy, mind to try
> the following combination(s)?
> 
> - btrfs on mdraid1
> - btrfs RAID1 on raw two HDDs

I re-ran the copies several times and never reproduced it. But I finally
hit it again after I gave up, while making a backup on 6.18.0 with
btrfs-raid1+luks:

    Opening filesystem to check...
    Checking filesystem on /dev/mapper/sdc_crypt
    UUID: f8223856-32cc-4dcf-8cee-9312e032c005
    [1/8] checking log skipped (none written)
    [1/7] checking root items                      (0:00:59 elapsed, 4875792 items checked)
    [2/7] checking extents                         (0:28:03 elapsed, 4583919 items checked)
    [3/7] checking free space tree                 (0:01:01 elapsed, 8253 items checked)
    [4/7] checking fs roots                        (0:20:30 elapsed, 10978 items checked)
    mirror 2 bytenr 870744010752 csum 0xdb1b27f0ca1a0139f7c65a0c0698a9a3f9e6ca6d624da7f70eecb3fc0f14ffc7 expected csum 0x2bce1cca32d98c3f83087f09980770a101b0560b1ddde7919fbbcd58a75f7d6b
    mirror 1 bytenr 2004063948800 csum 0xe3f0a16cc8f03705a89f81178d4617c2847d660b7171abe29b65b5b394a9aace expected csum 0xc85b7f37fb620e1a68754692fd7ca43846ca316de6485fc8a4b447bfeab78d78
    mirror 2 bytenr 3575828525056 csum 0xb9d9ee193d29b59b2015efed6151029c340a051c0338ec7ebca200363d304be8 expected csum 0xd645b7e5add1aa540a3440b78b7d31daa9545c925d32d2650d6bc61b7fdf4813
    mirror 1 bytenr 3714124914688 csum 0xcb2ff575e84a8e965b94bc8faf9e76d8f645742ee9cd503609efd78ac22623e4 expected csum 0x966b1d021450ffb6c47759161533e185f06a14a50c30ff881097a43b7ad6d6cc
    mirror 2 bytenr 4211891310592 csum 0xd1c11dabfa4bf3acea463479ab444bbc4c66dc9ba3257f09f4e1815bb46afac2 expected csum 0x17fff4d14269c69d84d267466c577ced3787fd9a9a445e36642067c47f129601
    mirror 2 bytenr 4328552914944 csum 0x02f75c04f1d921ce34f5b6b9bf40c3b0056971fc89989dad227fc45723938472 expected csum 0xdd6416d001ac47f16e68a24d1438244152355a0774142d4885e5a031c6938d93
    mirror 2 bytenr 4681011163136 csum 0x44c0b9d90fb258659e7377e93a96039afcadb501559a0cd831bf8c36f8fa1b2b expected csum 0x36c59223538807fc604537be5d686900031866626f3a1dc788755e92a74869cb
    mirror 1 bytenr 4808263344128 csum 0xfd6278ce98b1f15c8aefea981e5ba7a521fa1a08d0f642185abf72e215288618 expected csum 0x1108b8b604c5b21f7d7d80d32a1fd9c0c0e753cad8fb97967dfa3525105bf808
    mirror 1 bytenr 4993017057280 csum 0x033440e421102ec0c7b3057eae89dd80f300aecba70d3f1fcf5fe81c2cd6faba expected csum 0xb0e94e343b7291df9aae42a079bd0bba307a1c2ab81315361a49b0d8b6d53f49
    mirror 2 bytenr 5037246173184 csum 0x00b807ff8d0a31a79bb947e774c077916b0bd162dbf24fe43e4fca179e364214 expected csum 0x984635996e4c3fed6c701519e9f654b1b0adb06f3921522f6b687bbccd730271
    mirror 1 bytenr 5316786614272 csum 0x2805b36b130667ffaf187f1cc6bdab0802e5eb26332f3bae572202c9c34585dd expected csum 0xd7a2bab5bfddacddb610c6044504474c88962ed22d837a881faba8e4e60bee40
    mirror 2 bytenr 7293991006208 csum 0x68f917b93233bb6c7e49775c0c0deed66c47fe0027f3d4287a3b2c736fb25a1b expected csum 0x3662cf0b4a35cd0a0b71a475f35a92a6fefdcf21b7ee59a97b261bb6fbda1c8a
    [5/7] checking csums against data              (33:30:05 elapsed, 6082759 items checked)
    ERROR: errors found in csum tree
    [6/7] checking root refs                       (0:00:00 elapsed, 3 items checked)
    [8/8] checking quota groups skipped (not enabled on this FS)
    found 8848080683008 bytes used, error(s) found
    total csum bytes: 68538889856
    total tree bytes: 75102781440
    total fs tree bytes: 180338688
    total extent tree bytes: 340852736
    btree space waste bytes: 5344101189
    file data blocks allocated: 8776199127040
     referenced 8772977901568

The corruptions looked similar to the first time, couldn't get any new
clues out of them. Unfortunately it was on LUKS again because I'd given
up on reproducing this, I'll try without LUKS going forward.

I realized the common factor betwen the original repro and this one was
that I was additionally running an sftp copy of the same files over the
network while the files were being copied between the two local volumes.

    mkfs.btrfs -m raid1 -d raid1 --csum blake2 /dev/sda /dev/sdb
    mount /dev/sda -o compress=zstd:1 /mnt
    rsync -Pav /data/ /mnt

...and then, concurrently from another machine:

    sftp -ar nas:/data .

Can anybody else reproduce this corruption with that combo?

Otherwise, I'll keep working on narrowing this down: the tests take ages
to run but require very little actual human time from me, so I'm happy
to keep trying. Any other suggestions are welcome!

Thanks,
Calvin
