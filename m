Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TZWPTpn1"
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D5CE8
	for <linux-crypto@vger.kernel.org>; Sun,  3 Dec 2023 08:22:36 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2c9e9c2989dso19264951fa.0
        for <linux-crypto@vger.kernel.org>; Sun, 03 Dec 2023 08:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701620555; x=1702225355; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xjyI0NSqRP3tBZ/bxP+IFQUSUqwpEdqsPE0VFkTo74Q=;
        b=TZWPTpn1Tn79/cvxW4dKFweXzX39+RzcvjFJ92TtQPtx2kdxUNRrSgQL8n7QhRK2/P
         8LM9NDsURt/Zj19lAvtV9vK6hAfSV7uVVxbgiKmF+2J1EEi9B/SG9+MAIIH6W/uByf4b
         RAznWbKAqdbPBCH+v9X8GqoVd2BfxcFoNKIQtkVt6k4Sv3zDx4y0EZTvu7DtUux5mgj/
         vuLm9XDiSNASQPcMGN7aluyBUh0fOGR/WiS2lb2NqF8rXvixHKMnrZck3Ho6vF9rKHOX
         /MYSeBSqM1WQ+oy2SMimIDyOBQ+C9fuuyezdZ7oOqPvJnnaKZKsdYInMfLZpGmRnBV/M
         yhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701620555; x=1702225355;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xjyI0NSqRP3tBZ/bxP+IFQUSUqwpEdqsPE0VFkTo74Q=;
        b=J1qeT/3UmtXSWWH8Xz+sBeuIkC1kCNpquICG/yl0uNt4zrDlhQhEHW76oDH6dkfkBk
         0xjSeUuq5z9Nj8YE1+fG4hpaGF8NYx6z9/D6L7nJHeTvOD5SeOWjQ1rE5WUaGMCGFrqP
         hgy9t3CdFroHt8Qum3nP6QjnrIvm4DZpZ4csZZAIDfFStLtJ1t6KsjeieTAKgQZRcQAG
         NemsyZEUqBmYjtWGXRru4r9S7+ZlZklhO8Uoz+KlRCO33u251RbW1Ik7+s035shi92s8
         RsvmXzdcvGAXd3lMyjLnWYItXq806mrjNr1+YsrhO5Qh2Z+6Eaps10r98C7GmtFHkuBV
         xUPA==
X-Gm-Message-State: AOJu0YxP1vZoJxAq6GEc35docyWAvo286uAkvFoVUctB87pU3aVOkFie
	yl/CoaaX7hW4NdLljYOnV/qylcUuuBON/V+BzxA=
X-Google-Smtp-Source: AGHT+IGSGcEaIEtQqGblPrNkKc0fnKaGWMp7DebWCNmAF4TiNMHeKf+g1bbPlsKipqb59zTR2qB3Mxa048rMnBy3als=
X-Received: by 2002:a2e:8645:0:b0:2c9:e68e:aded with SMTP id
 i5-20020a2e8645000000b002c9e68eadedmr1460629ljj.61.1701620554728; Sun, 03 Dec
 2023 08:22:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Mon, 4 Dec 2023 01:22:23 +0900
Message-ID: <CAD14+f2AVKf8Fa2OO1aAUdDNTDsVzzR6ctU_oJSmTyd6zSYR2Q@mail.gmail.com>
Subject: Weird EROFS data corruption
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, 
	Yann Collet <yann.collet.73@gmail.com>
Content-Type: text/plain; charset="UTF-8"

(Cc'ing f2fs and crypto as I've noticed something similar with f2fs a
while ago, which may mean that this is not specific to EROFS:
https://lore.kernel.org/all/CAD14+f2nBZtLfLC6CwNjgCOuRRRjwzttp3D3iK4Of+1EEjK+cw@mail.gmail.com/
)

Hi.

I'm encountering a very weird EROFS data corruption.

I noticed when I build an EROFS image for AOSP development, the device
would randomly not boot from a certain build.
After inspecting the log, I noticed that a file got corrupted.

After adding a hash check during the build flow, I noticed that EROFS
would randomly read data wrong.

I now have a reliable method of reproducing the issue, but here's the
funny/weird part: it's only happening on my laptop (i7-1185G7). This
is not happening with my 128 cores buildfarm machine (Threadripper
3990X).

I first suspected a hardware issue, but:
a. The laptop had its motherboard replaced recently (due to a failing
physical Type-C port).
b. The laptop passes memory test (memtest86).
c. This happens on all kernel versions from v5.4 to the latest v6.6
including my personal custom builds and Canonical's official Ubuntu
kernels.
d. This happens on different host SSDs and file-system combinations.
e. This only happens on LZ4. LZ4HC doesn't trigger the issue.
f. This only happens when mounting the image natively by the kernel.
Using fuse with erofsfuse is fine.

This is how I'm reproducing the issue:

# mkfs.erofs -zlz4 -T0 --ignore-mtime tmp.img /mnt/lib64/
mkfs.erofs 1.7
Build completed.
------
Filesystem UUID: 3a7e1f90-5450-40f9-92a2-945bacdb51c3
Filesystem total blocks: 53075 (of 4096-byte blocks)
Filesystem total inodes: 973
Filesystem total metadata blocks: 73
Filesystem total deduplicated bytes (of source files): 0
# mount tmp.img /mnt
# for i in {1..30}; do echo 3 > /proc/sys/vm/drop_caches; find /mnt
-type f -exec xxh64sum {} + | sort -k2 | xxh64sum -; done
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
293a8e7de2a53019  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
293a8e7de2a53019  stdin
293a8e7de2a53019  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin
0b40f1abfbb6e9a8  stdin

As you can see, I sometimes get 0b40f1abfbb6e9a8 and 293a8e7de2a53019 in others.

This is when I manually inspect the failing file:

# echo 3 > /proc/sys/vm/drop_caches; xxh64sum
/mnt/vendor.qti.hardware.mwqemadapter@1.0.so
dc96f35f015a0e5d  /mnt/vendor.qti.hardware.mwqemadapter@1.0.so
# xxd < /mnt/vendor.qti.hardware.mwqemadapter@1.0.so > /tmp/1
[ several more attempts until I get a different hash... ]
# echo 3 > /proc/sys/vm/drop_caches; xxh64sum
/mnt/vendor.qti.hardware.mwqemadapter@1.0.so
1cfe5d69c28fff6c  /mnt/vendor.qti.hardware.mwqemadapter@1.0.so
# xxd < /mnt/vendor.qti.hardware.mwqemadapter@1.0.so > /tmp/2
# diff /tmp/[12]
3741c3741
< 0000e9c0: f40e 0000 b46b 0000 ac5c 0000 140e 0000  .....k...\......
---
> 0000e9c0: 445a 0000 e40d 0000 ac5c 0000 140e 0000  DZ.......\......

This could still very well be my hardware issue, but I highly suspect
something's wrong with the kernel software code that happens to only
trigger on my hardware configuration.

I've uploaded the generated image here:
https://arter97.com/.erofs/
but I'm not sure it'll be reproducible on other machines.

I've also tried updating the LZ4 module in the /lib/lz4 to the latest
v1.9.4 and the latest dev trunk (4032c8c787e6). I've managed to get it
working with the Linux kernel, but the corruption still happens.

Let me know if there's anything I can help to narrow down the culprit.

Thanks,
