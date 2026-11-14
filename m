Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.88.161
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626843;
	b=3af3JHvfCZAcesEorsiBDGGy7Lq9k4gBITlaFlpJhEod8EyRxP8Ypyrn7Ox+WGkFB4b/
	 GR5u6dOikr2xASz/An3/qLq5MytdiO4DB1Le2UJBEdX0qdzQnaGSC6hOYJ67amHfObvYO
	 jdoKROdtdB9wGiYLKY42L0IqgJN9aMBZMvKoXUmck2XVQkdEwNuRrZC4Tf2R13pwYmW9p
	 N34+xSlB1AbWAN79ZJyAZlSAR5vIIs2NvYPgqpKqGvMF9pkiGhw5pw6Y3koPRTY6XVZK1
	 wqoD+M5OGIN31B3K3G7GaNxPaObhSt0gJtT+RPvjvPoNeHusrXttRgH0AnMcfJpZWnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626843;
	h=DMARC-Filter:Received:X-ICL-RepId:Dkim-Signature:
	 mail-alias-created-date:Received:Content-Type:
	 Content-Transfer-Encoding:From:Mime-Version:Date:Subject:Message-Id:
	 Cc:To:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Info-Out:X-JNJ;
	bh=3ah/TscWt//9fJDWOth8C3PcjS1jtwJy3eVkp1yjoD8=;
	b=W960dXQPW2dvFjePv8tsbxJTqxCm/i+n9p+uFlsA55eDzJzTLyYh00Rw7mllBUG0dR5t
	 L9NcLFg69l4aK/MosKQv+kyj52yRwoJ6taVjsnNTP3euvXp+f9HALdCjtlwFArG4i687D
	 D1RBhE10M+o9h9pQGoRztM1CUddtgVR+gLbSpWNqJjKccZE72nUM8yuYAZP8zcDBK8gvm
	 I3RIlQjkcqqzoF21hqMoU30pm7wkDrs/O8BbPnk2xdDed+eJWfNjx8HBydu6pWapdKw7I
	 Iv6efsCQUkpRFfT//cdijqnRCv7F/vKKc0vJ38Gns7oyQAHkhcCXzA6rWQF6HNfwkKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=cronstable.dev;
	spf=pass smtp.mailfrom=cronstable.dev;
	dkim=pass header.d=cronstable.dev header.i=@cronstable.dev header.a=rsa-sha256 header.s=sig1 header.b="avUO9/F+";
	arc=none smtp.remote-ip=57.103.88.161
Received: from outbound.ci.icloud.com (ci-2002c-snip4-11.eps.apple.com [57.103.88.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6012D606A883
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 03:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6012D606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cronstable.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cronstable.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cronstable.dev header.i=@cronstable.dev header.a=rsa-sha256 header.s=sig1 header.b=avUO9/F+
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-8 (Postfix) with ESMTPS id 19624180101F;
	Sat, 14 Nov 2026 03:27:20 +0000 (UTC)
X-ICL-RepId: 01a1d818-68e9-7632-9587-6a9aac6be57a
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cronstable.dev; s=sig1; t=1794626842; x=1826162842; bh=3ah/TscWt//9fJDWOth8C3PcjS1jtwJy3eVkp1yjoD8=; h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:To:x-icloud-hme; b=avUO9/F+vlrsU95Z/iJX8hrz2VkaZUZ3s72ePG57lix1yQxq6fFK7D14LK+9OKMbvo57Rbgu6OM1bbu+GynpcmW1S+KAUbcbJkGI3wn7DoBqjLlt7oOiMn8Q5Pu4+CzAf/AZH8WnPpaXOsLmzG8EH0U63x2T8i7ElFGMmm53AWsNIJ5EN0fF61uKdJgcRjGv6kvV5wG/D8SjFpcuFyRVqkvxtnhURrxTAtOOGurwxJ1on307tq0tode18SVplxOgcwOZljvrHMvjBhkNiiLqCHDnSCLNGJ6HeISid70FkQV+mqmlvKo0KkabfW6rYKYlCY293Ck8O09MoU5843rlIg==
mail-alias-created-date: 1786142479336
Received: from smtpclient.apple (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-8 (Postfix) with ESMTPSA id 39C391800C66;
	Sat, 14 Nov 2026 03:27:20 +0000 (UTC)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: parker@cronstable.dev
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (1.0)
Date: Fri, 13 Nov 2026 22:27:09 -0500
Subject: lib/crc: x86/crc32c: question about the "Future work" note (crc32q + VPCLMULQDQ on Zen)
Message-Id: <84998C7E-A862-4483-BB1B-D2C63AB45C7D@cronstable.dev>
Cc: linux-crypto@vger.kernel.org, ardb@kernel.org
To: ebiggers@kernel.org
X-Mailer: iPhone Mail (24C5037i)
X-Proofpoint-GUID: COQ2YaVXLVPJnVDtmYnTCaDMfN4Atx5k
X-Proofpoint-ORIG-GUID: COQ2YaVXLVPJnVDtmYnTCaDMfN4Atx5k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE0MDAxMyBTYWx0ZWRfX2MSE8moypsp9
 lMhOv49jOysY9tc7YybXP6tVCNFK9S+c5sSEogSQgZKaTDFyfN8yJ5IK255I4g9pXwG0zm6zx/Z
 speXiHEnSvL2cUd3QhDvL2ttfsqmlYywkCGvT/Fv+Q6J/I9cibNuBz2gjzrgPaRHybejWqhoHda
 ObiZKBxYPTqEX64cvCnJ3bv3/duNmoh4N3kaZ2Hz4XOj5t0RHDHdS3/XNC0gT7CmRE3sm93as/a
 FT5G8f3w9/+eaJGEDYnahfK4WvxoQDBw+NG4c7/SmsL55kSJHti3v4nSrpxs7J0T84FB0RFecXS
 ind9Ri5/CcymgXCRftDobJ2cvy8iFl4Zq2EjSxpxC1nh7n8e2zDZLxU1fO5LvA=
X-Authority-Info-Out: v=2.4 cv=WrYm8Nfv c=1 sm=1 tr=0 ts=6af7d519
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=LEAcPSDhJbP4U6-UQGEA:9 a=CjuIK1q_8ugA:10
X-JNJ: AAAAAAABlJxnty5Xdfc0ZYBTJiA9JpIHS6Ag4LZ/nNZZyY+kJapvpOU+rQKzj17gTYfrx+
 fgBXqy4E+ULqXPTh46G11FYj3v4oYy4k3B8KwDB2BoeveHbFq4dGr6H1p/bzg2gq9Vr8nU
 cdUat/eD/IuXTo+6vSTSbCYYN6W8XTZbiMbbwNx8ztvx4RgeTmxTvQlKCYi/telnie5Cxb
 x/rPhRaO0P0eGUBb0pmP3kJQryNWO+pHLR97fCB4QrvwJvOXJPH2YQ0sMkD0IlnatFSEIr
 HVvSdN2Qeu7vA978uaxJShMb0o0E5yabH22x4w2OJzlqTK5FzM8Qpn0hpXKY05Im/+9TTe
 /5BzR1+RJgbTHP2Np7vIcX0NUrWxsqIFTJTDgXpXx8ITmCVboYW8Q1IqoqKtRhaU3m9HiJ
 7bLK31DlBd1LP8HJ6ODGmyWwHulg6sPRFEPGudNrinl0X7Qwj1Tm66VkL2f6q0vvQtSBLB
 gLuBvYzB45ap8iCDSPkUytOpv0jkSid1fOR2xlsP4LgbAxXb5Cv5LBlH4+CK82gfrBWqcL
 BQd3FnegkvyYW0Ru2XQWv2BnOnU+e0rl38NNPTh7A9v9TqQLr6MY3MtvdGWfeK1H5cMYCw
 tEp0BYbk3T35Uh9GZWYpw8ytEM8HFFerVRAIXN2ZaaSSiRL7R1c+5n7bb6kSSo3v3Rii98
 uvdEBUYDDs8lIf9FqApMS0XOB7bYShj2OPMp1DjfgIhUPa74OXLOT6ZYxga9GYKS3nNVFT
 vMUwLrJR9ThvJUMKcEfJ4Ze8ODI8eDN9HwQN5dev/p1TWuSu8rV19SpdOhMBhY2sDjAIIG
 y6+NyAh+NIPjbC9nobBD5s+Nlmv3Lkvx+ePnrJ9NIQE6IMxZWkHnSW6edA719J5pgtz9dO
 U7DhmjRKJOxMxrU7Duken/Y/eTzPRfsF0cl5M/vsvrVctqGiQhzyWAP6y3AxhWq6V1GGK6
 9d08W9u6Sv2Ad+xWKuf1yjhx8brIiFpBVc6vXrT69BOISo39/QyMl+KPowVPO7cKpZYVBa
 V8kEVT8Jq5HH8ErCBBc+iw2QnhV2T1ptOUF6VrGEeZ0sR7cbnOpWVBNnzkzw+du64GbB3h
 v1GvPtU6zetHTIOHQmATeer1MyQfHaEdo5PbkLIIPTuIFYs1WDXNGjbVB7EkXKukKs5AbW
 U69RI0V8x4LuR87u336ODOxqCzVrE+RCOhscsjSjoaefrGBasaxkIGo9S8BsSX7ySPTOHb
 z5FyFSt7t8KnyrEdSEe5x3g9kXTm2jDjvQEpo8w5QBSCSGJJG7TvOj1QNRbSGGNhzAaItM
 ZZ6iYcLBpBuwWcHG4iFBm+ZIgEN10/gRKDqTR0p5o6nLa/GREiqeSNskeoSfVBSjw7Gllw
 h+c27vtjc4hKP2Fkz5YGgIPMemEXpBE60fiiL5SVkkrJ6soJsMM=

Hi Eric,

There's a comment in crc32c_arch() in lib/crc/x86/crc32.h that says that
the optimal strategy on Zen 3--5 is to use crc32q and VPCLMULQDQ in
parallel, but that different numbers of streams and vector lengths are
optimal on each microarchitecture.  I've been experimenting with this on
Zen 5, and am curious about what you're looking for here.

I've tuned an impl for Zen 5 only: two zmm registers folding with
VPCLMULQDQ while four crc32q streams run alongside, merged at the end
using multipliers from a 1 KiB table.  Compared with
crc32_lsb_vpclmul_avx512() at len=4096:

    AMD Ryzen 7 9800X3D (Zen 5)            +53%   (crc_kunit)
    AMD EPYC 9V45 (Zen 5)                  +57%   (userspace)
    AMD EPYC 9V74 (Zen 4)                  +15%, but slower at len=1024
    Intel Xeon 6975P-C (Granite Rapids)    -43%


1. What would you want a solution to look like?  A variant per
   microarchitecture, a single variant for whichever one is worth it, or
   nothing until there's an approach that covers several of them?

2. Would a Zen 5-only variant be acceptable for now?


Thanks,
Parker

