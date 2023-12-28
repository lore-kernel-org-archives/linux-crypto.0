Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E77310E6
	for <linux-crypto@vger.kernel.org>; Thu, 28 Dec 2023 02:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="EVG2idgk"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d427518d52so26283695ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 27 Dec 2023 18:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1703730538; x=1704335338; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L9b6zoFhTsQdqlwbUa5zffkYVuCCwTirUAw7XRk7ZME=;
        b=EVG2idgkQ/dH0EQN3xaCwwcLL7uvgiFGWigC1BEE19SHZYBNDOG2AAKFC3JpjUM6ph
         Fm8NssbKa8Ng12qBcx+L//a79E0o5sy0IQyczrRwkPR+NDusVeOFfc+3SqBGCXzoexAq
         mkV0Bf/3GhsSKeU5d23egwYn56yrqPewR304018yRiVNHxsbAUnXtUdlJ1fo4aijn/63
         gnsvvGfSGvNUVdIKfOnchEVwC/MuAG9oMhMdpD/h6AI5BGpaSrlZkVL2pvyYbtTcNxXR
         45adEEXCB5/YGDRLerUsFEhSFlVRELD2aL0W+5w8X+kyK+DWYgbXiztIoVUez3pft/6m
         Ut1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703730538; x=1704335338;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L9b6zoFhTsQdqlwbUa5zffkYVuCCwTirUAw7XRk7ZME=;
        b=HnOdLzi9qf4iydg2ovQzLCV1VO90QIHuiY4dl2mjJUVLmrXo1Zb7n2z8i0zUcOjGNl
         ZNd3jxZ6D7HdYQ0I9ZHznMcYtB8WBFKrB33XrszV74TsDw69TngORXBT3pV2UJpLocoA
         T6SOG2CnVt7klRcrBG8jjO4GwYqc1BD7bbXcBwW+VAAK1AYFcLZpRI8/c49rYauNwQL2
         7MRpyvRuRS49j/XLNmsag3dQGI7/8L4bOV/JMRP6Cid4y27Rehj2je3n15M9bpAfE8aB
         Zag+WU5cPekHnPUjX74bE7ci3etFTzb368GVa1K75gw0ulujDzIJlWtdlFfafkeD2Y0O
         oKoA==
X-Gm-Message-State: AOJu0YyT8DzOVMTNaJm0I28s+Kdp0A9VWqUD9ENsNTgxArUmF4y0pK08
	v0hFe2cEPjDRIIk88Y1erbK9XDJlUxmQ7EUMMsqxFjy8e4w=
X-Google-Smtp-Source: AGHT+IHQP6848dz6WO2/MRcWA0EKWw6u4tZgtShfJWCF7j5g2cz9p431rCkqyxXJt+yAd9Czf79IMQ==
X-Received: by 2002:a17:902:c412:b0:1d4:3dfa:6060 with SMTP id k18-20020a170902c41200b001d43dfa6060mr9704231plk.52.1703730538535;
        Wed, 27 Dec 2023 18:28:58 -0800 (PST)
Received: from [10.5.81.224] ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id n10-20020a1709026a8a00b001ab39cd875csm12695873plk.133.2023.12.27.18.28.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Dec 2023 18:28:58 -0800 (PST)
Message-ID: <59815d0e-2f44-408e-a81d-989df3323f72@bytedance.com>
Date: Thu, 28 Dec 2023 10:28:52 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [crypto?] general protection fault in
 scatterwalk_copychunks (5)
Content-Language: en-US
To: syzbot <syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, chrisl@kernel.org, davem@davemloft.net,
 herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 syzkaller-bugs@googlegroups.com, yosryahmed@google.com
References: <0000000000000b05cd060d6b5511@google.com>
From: Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <0000000000000b05cd060d6b5511@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2023/12/26 23:28, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    39676dfe5233 Add linux-next specific files for 20231222
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=172080a1e80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f3761490b734dc96
> dashboard link: https://syzkaller.appspot.com/bug?extid=3eff5e51bf1db122a16e
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178f6e26e80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c399e9e80000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/360542c2ca67/disk-39676dfe.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/900dfb21ca8a/vmlinux-39676dfe.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/c94a2a3ea0e0/bzImage-39676dfe.xz
> 
> The issue was bisected to:
> 
> commit 7bc134496bbbaacb0d4423b819da4eca850a839d
> Author: Chengming Zhou <zhouchengming@bytedance.com>
> Date:   Mon Dec 18 11:50:31 2023 +0000
> 
>     mm/zswap: change dstmem size to one page
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15f60c36e80000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17f60c36e80000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13f60c36e80000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com
> Fixes: 7bc134496bbb ("mm/zswap: change dstmem size to one page")
> 

#syz test

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 442a82c9de7d..b108a30a7600 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -117,6 +117,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	struct crypto_scomp *scomp = *tfm_ctx;
 	void **ctx = acomp_request_ctx(req);
 	struct scomp_scratch *scratch;
+	unsigned int dlen;
 	int ret;
 
 	if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE)
@@ -128,6 +129,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (!req->dlen || req->dlen > SCOMP_SCRATCH_SIZE)
 		req->dlen = SCOMP_SCRATCH_SIZE;
 
+	dlen = req->dlen;
+
 	scratch = raw_cpu_ptr(&scomp_scratch);
 	spin_lock(&scratch->lock);
 
@@ -145,6 +148,9 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 				ret = -ENOMEM;
 				goto out;
 			}
+		} else if (req->dlen > dlen) {
+			ret = -ENOSPC;
+			goto out;
 		}
 		scatterwalk_map_and_copy(scratch->dst, req->dst, 0, req->dlen,
 					 1);
