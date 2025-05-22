Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960AD2F85B;
	Thu, 22 May 2025 13:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747919446; cv=none; b=bb/0DNqdnvvTHmts2jJ7iQH3MwXTv/yWSwNdTtF/nbBqCSNRCFzSozqH8z72iiM0/7VXWqUcddWWzekQIQlUISqpKylfddh3T2n8qvId7RZDCq0HdpXhNsR8DwGm8QbGyM5K96zBDZe3G29fRV2VGQHwGgdPPrl7uCv0hdVYie8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747919446; c=relaxed/simple;
	bh=4RO+ZVNYclCYbas2PTF9cypJ+dqERh2DHg4PqTJnmD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u5tRXlv5kVa2oqBdfyyKq7EqkGmdexC2Dod6RCuZM2AbDjc2nP46FUITdTBejTf1TqS0mxN0nKM2qJe7RMotbmp/fzv+S1k9T/7uE2cHI0qFeFbbqgylJLnHrH5Xtflb9rJhd5e3MTRNggZRt1xpYxjV/5hr2Vm7bhqOqsHTZFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=none smtp.mailfrom=foss.arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=foss.arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 971D21A2D;
	Thu, 22 May 2025 06:10:29 -0700 (PDT)
Received: from usa.arm.com (GTV29432L0-2.cambridge.arm.com [10.1.25.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 777ED3F673;
	Thu, 22 May 2025 06:10:42 -0700 (PDT)
From: Aishwarya <aishwarya.tcv@arm.com>
To: dominik.grzegorzek@oracle.com
Cc: chenridong@huawei.com,
	daniel.m.jordan@oracle.com,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	steffen.klassert@secunet.com,
	broonie@kernel.org
Subject: Re: [PATCH] padata: do not leak refcount in reorder_work
Date: Thu, 22 May 2025 14:10:41 +0100
Message-Id: <20250522131041.8917-1-aishwarya.tcv@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
References: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Dominik,

I wanted to report a regression observed while running the
`kselftest-mm` suite, specifically the
`mm_run_vmtests_sh_migration_migration_shared_anon` test, on an
Arm64 Marvell Thunder X2 (TX2) system.

The kernel was built using defconfig with the additional config
fragment from:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/mm/config

This works fine on v6.15-rc7.

A bisect identified this patch as introducing the failure. Bisected
it on the tag "v6.15-rc7-7-g4a95bc121ccd" at repo:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Failure log:
11193 03:29:14.806502  # # running ./migration
11194 03:29:14.806876  # # -------------------
11195 03:29:14.820939  # # TAP version 13
11196 03:29:14.821236  # # 1..6
11197 03:29:14.821519  # # # Starting 6 tests from 1 test cases.
11198 03:29:14.821773  # # #  RUN           migration.private_anon ...
11199 03:29:34.602964  # # #            OK  migration.private_anon
11200 03:29:34.603418  # # ok 1 migration.private_anon
11201 03:29:34.603687  # # #  RUN           migration.shared_anon ...
11202 03:29:34.973479  # # Didn't migrate 1 pages
11203 03:29:34.973855  # # # migration.c:175:shared_anon:Expected migrate(ptr,
self->n1, self->n2) (-2) == 0 (0)
11204 03:29:34.984787  # # # shared_anon: Test terminated by assertion
11205 03:29:34.985105  # # #          FAIL  migration.shared_anon
11206 03:29:34.985365  # # not ok 2 migration.shared_anon
11207 03:29:34.988568  # # #  RUN           migration.private_anon_thp ...
11208 03:29:54.597572  # # #            OK  migration.private_anon_thp
11209 03:29:54.597951  # # ok 3 migration.private_anon_thp
11210 03:29:54.598487  # # #  RUN           migration.shared_anon_thp ...
11211 03:29:55.011183  # # Didn't migrate 1 pages
11212 03:29:55.011524  # # # migration.c:241:shared_anon_thp:Expected migrate(ptr,
self->n1, self->n2) (-2) == 0 (0)
11213 03:29:55.022519  # # # shared_anon_thp: Test terminated by assertion
11214 03:29:55.022834  # # #          FAIL  migration.shared_anon_thp
11215 03:29:55.027864  # # not ok 4 migration.shared_anon_thp
11216 03:29:55.028156  # # #  RUN           migration.private_anon_htlb ...
11217 03:30:14.595327  # # #            OK  migration.private_anon_htlb
11218 03:30:14.595777  # # ok 5 migration.private_anon_htlb
11219 03:30:14.596398  # # #  RUN           migration.shared_anon_htlb ...
11220 03:30:34.595239  # # #            OK  migration.shared_anon_htlb
11221 03:30:34.595623  # # ok 6 migration.shared_anon_htlb
11222 03:30:34.595859  # # # FAILED: 4 / 6 tests passed.
11223 03:30:34.603816  # # # Totals: pass:4 fail:2 xfail:0 xpass:0 skip:0 error:0
11224 03:30:34.604110  # # [FAIL]
11225 03:30:34.604342  # not ok 55 migration # exit=1

Thanks,
Aishwarya
