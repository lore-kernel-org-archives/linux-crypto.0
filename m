Received: from outbound.mr.icloud.com (p-west2-cluster4-host8-snip4-2.eps.apple.com [57.103.69.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D955274668
	for <linux-crypto@vger.kernel.org>; Sat, 30 Aug 2025 03:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.69.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756524537; cv=none; b=CE4VHjYJwWevZKlHjy+woVqbHfb/sQw0GJ61lXq83qX+dCywOZi+Q+AOzUUBvEYCx2rexjwQkH+HPaH3jzFHiQnFJE4EzY6x55aR7oQSgZDxAT8tApcs7a0+ZJFNLsxcmsTL2pR/UksPKaRT3NWG08Ilj/v7CibI0cJL0Uy+ItU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756524537; c=relaxed/simple;
	bh=oAJaJdqcidptvzmYMl2IOWbM7fLuPhubxk7so3LFLPU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GexTIeH1m91G5JuJKltu3XhAT4lJP2sedA/Oo80nVKyEE3KQFd9jfkfOHja4raKyB1wEyVEfd1NvsbSGz28eOii7exgqVCNK0K9T2kSSGb/Z2mSgbv0XlRUlxNS/YugQsrRYkpsphdmL8Rkmk1FnPGDFRqav6gOVkmzgoDV4k2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=vkpzfyxa; arc=none smtp.client-ip=57.103.69.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="vkpzfyxa"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-0 (Postfix) with ESMTPS id 950041800174;
	Sat, 30 Aug 2025 03:28:51 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1; bh=1IpNM/gXHPSSSkkDpJXK8IZa6rUz5T5Ra5Vu8zrL17c=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=vkpzfyxawFwl6wzlx3oLzUk+ZPU3p8NoMtsx8naW5iO2uCNZOYPyjupY6K7cbww1qGRvsyz/wvHFTMU4/Wc0KP/kOdaxM7kBgKiOZ3JZDW+zF3FJhC0jb/mVbulix9IrmaO4Eq7cXBsUcSyRQcc/ysTIu8sIeZg2S032K9x9R/oZ2aXDRNcx9hOl+QOGz2L/PZJ8atuA9nS90j+ppKEZ1kZEeOBatKZnQlLA8GdbBJB4em4OSOS6yiFZHjAXofIu5rp8BtTdyE6Ri5Up1nGHc7bZWAcbmO4lCW+YL/tYuQwvOuEdV+gNOPpJq53NxA51uqs4K2sdhYVCAWulZoA7Yw==
mail-alias-created-date: 1632196724000
Received: from hitch.danm.net (mr-asmtp-me-k8s.p00.prod.me.com [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-0 (Postfix) with ESMTPSA id B6FDF1800143;
	Sat, 30 Aug 2025 03:28:50 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: linux-crypto@vger.kernel.org
Cc: dan@danm.net,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	regressions@lists.linux.dev
Subject: [REGRESSION][BISECTED][PATCH 0/1] v6.16 panic/hang in zswap
Date: Fri, 29 Aug 2025 21:28:38 -0600
Message-ID: <20250830032839.11005-1-dan@danm.net>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX+Lts1DYLmsza
 yZieEJw/u+LvJf89P7CPh3Y7XlU1DL2tV9hpzdJZGfBqUUnMQP2tiR13z/3IAtV8Q3Box+qolNF
 n8TfXII46P6Md9BColk+sZ7SVoNeE9MkwjrCQnfD3UU6Wi7bzBpcShLK8o294fTI81NsGg8klBW
 e1wr4FVcs51dk+lVq3/Fk4Ds8djuBPg1yApv+fgxIllnmNetlo98KB/hHToQrSRVFUJ2bS1qF9d
 zIO1vunjPOkmvtM4WQlqtspWGy7s4pETO6e1pXtJsyYc+ZgnNngCq41ZExDynHUnBODsi3g6Y=
X-Proofpoint-GUID: iVIHFsv660FxQ85KPsH7ixBo8Q0awJwa
X-Proofpoint-ORIG-GUID: iVIHFsv660FxQ85KPsH7ixBo8Q0awJwa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-30_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxlogscore=999 clxscore=1030 adultscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2508300032
X-JNJ: AAAAAAABq91JXbT91Y9sZnoI8YmqcEVjaAPZme6LZOS+Vfv0o2QP4pelurMzGb2FBlh7+09Hv3fEnE7+y0kVnbmCchI0WJbWTIjh87zzNlnMal2O2Em6uCSpu7eCxJejIm2/PGNn10fp8d7+jg0IOpSxQB8AnCFJ1+jtmsn9M+IdtiH5yuqaVvnaGSnqeNqjN4ztalpyuts+YXAU/9dE1e6OBVlsT7LCXwEujdSst8LNi2+dFhJJWxXDU8DzxNbYTKxK+cB2jWbIQNY6nlPFjHKbTAAActRNUqR+tBn1ci5biyKMY10fqDoXyMIAt+NqVJjUjHHjI2onZMvwqiITbw4i8yfBzFLEyq9z4d1pq/faSyb+KjzSEByo10U5stNGMjAMUACWOKXFhq+QgkzPcjicVbUWuplLGdBbHG1tLmzUcEOHK3SMZVUTmSe6xCP8ekQlqh/j1Y48uwx8Dhe8E+5V/PGFQpIS80gwaTUqlLlyuKHxG81F16t/srr58iBab0WGurG2edAVW9F4yh7mgPBn5VRksC2bofvkHF3n70oOdfPHz4VTYLoBdDnJBKL6cknga96w78Zawy+aKBHxX9RC71PwSkm2K5zF9SQNdR13NmO2Jg==

Hello crypto folks,

For some time now I've been battling a system hang that has been
sporadically affecting some of my machines. It seemed to be introduced
sometime during the v6.16 rc releases, but I couldn't quite pin it
down because it was reproducible (though not very easily) in some of
the versions I built, but not in others. The problem seemed to come
and go. At one point I thought I had bisected it to a netfilter fix,
but that ended up being wrong and led nowhere[1], and I was about
ready to give up on it. Then just yesterday one of the machines that
had been sporadically encountering the issue finally produced a panic
instead of just hanging. The panic indicated the problem was in swapd
in the LZ4 compression code (all of my machines that have been
affected use zswap).

Armed with the knowledge that it's a swap problem, I tried to find an
easier and more reliable method to reproduce the problem to try to
better bisect it. I found that I can use the stress-ng[2] tool's page
swapping stressor to immediately and reliably reproduce the
panic. Then, on another affected machine, I ran the page swapping
stressor and also immediately reproduced the hang (so I was fairly
confident that the hang and panic were both caused by the same
regression).

Then I tried bisecting the problem and immediately hit a new snag,
which was that suddenly on a new build of v6.16.0 I couldn't reproduce
the problem, even though I'd reproduced it on that version
before. Eventually I began to suspect that structure layout
randomization was causing the non-reproducibility (and was the reason
my previous attempt to bisect it failed). Using the randstruct.seed
file from one of the known bad kernel builds I had, I was able to
confirm that randstruct does indeed affect the issue. Now with a
"known bad" randstruct.seed I was able to successfully bisect it to
commit 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation
code into acomp"). Instead of just reverting that commit, I tried to
understand why this change would be affected by randstruct, and I
believe I found the problem. Two related structs require the same
ordering of a couple of fields but one of the structs is new and would
be automatically randomized by randstruct (because it only contains
function pointers). I put together the following patch which resolves
the issue. It works by making the two related structs use a shared
struct which can be randomized and still ensure both of the structs
end up with the same layout.

-- Dan

[1] https://lore.kernel.org/regressions/20250731194901.7156-1-dan@danm.net/
[2] https://github.com/ColinIanKing/stress-ng

#regzbot introduced: 42d9f6c77479

Dan Moulding (1):
  crypto: acomp: Use shared struct for context alloc and free ops

 crypto/acompress.c                  |  6 +++---
 crypto/lz4.c                        |  6 ++++--
 include/crypto/internal/acompress.h | 10 +++++++---
 include/crypto/internal/scompress.h |  5 +----
 4 files changed, 15 insertions(+), 12 deletions(-)

-- 
2.49.1

