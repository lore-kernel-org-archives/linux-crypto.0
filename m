Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451197;
	b=4uV/6uZBbZhYxT4APiHaJX4cyDfx+ujEsihBV7Rxad1ZfpDL+AYtoTWUcDHj8ntQGCrc
	 av7F//J2iTaewY4IC0swtO9/2aGJ9XFfFxJC5XMWwQ6SBGTJH/l72MBLV18m/S/6Sjf5u
	 FTs2qGIydLqfMopFsji3YjXsu75jyfAgl+isROqRxnmFegAn4IKHPSC8+oNEalE2IVWES
	 Q2E5J6mG3QXC+1N+lRnej/G73riLNtr+irYYc6DE4wxZjYNlJDrgP0F1EqwOHh+v4Q4IK
	 NhdllbyEaKjlJ77qGnMED7h8ZArScUevGuqUVuv3GaRcx+RmnVWoGJadc+5rVUL0RFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451197;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Subject:Date:
	 Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=ttjFAksKw2UfS2qrCr46pXdd6AD6Qqu2A/488cHQln8=;
	b=cssuHaMDFB+1OBsq9rYNzghY98XQ1of6aReqy4QIw8wQe8fe6eSDRK+pXEQsXt/DVVe5
	 jVf89WB3VQSuB8K+IPJB5BEqr7xRVAgsDpgWNwhchjbQ3Wtcx5oR0fGh7RdIU5yg3PeLB
	 hactks9esPpduoOKjBZqg+azC7NovjdNIbF5a/JCnd618BKimgrgby7DH8bnBRX0RPF0X
	 45oHFj+iuJLDSUCNZjf8qaf53zseizN9lEzHfURtWPhWfOeYgyBl9Zt+qKiq7tcQDfJ/E
	 JQ5qV706TkjkLmalVZ5yU3hX9bNA8Z5n2wKL4EYCqN3psdrK7hI69llS3YCRR+708AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=F9LmZZW8;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD61606A31F;
	Mon, 19 Oct 2026 23:06:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDD61606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=F9LmZZW8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792451196; x=1823987196;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=SmF3Ilp5Gj/wTCaoZJEP+WS0uyo4jMKUdrQfhjNUfTU=;
  b=F9LmZZW8PDJqPlgqPJQBRd1Y+Jw5JaOLpBZSXcW+i9XcBz+GiUgD8PaQ
   4c5IzzalmXS44hLdWAJ4yfWz4WahzMM/ifLQVKGAIa2rWONWPurSMHU9d
   rkBpvQEHlStBbdLGCeC9guDFseIsOexhXW+aJzDoAFdC8hUZ4le82z+9O
   tT7irBdTFG2GA1MQCVy46ggtOhsFNsQHWri+dtvpeXO22i4OvPa8H0zFa
   0q+NupkWbdiNQoxGwG6GloS2hmdXsFeFDEFSitjYX49Cs8A0tS4PwqIZX
   bRTlq8/pu5ifICQASgGvPdaV8EL3CCy1M7ReDYZTe1icdKlCkY7IJ3aAt
   A==;
X-CSE-ConnectionGUID: usg2NADmSgucQ5s3BDWTwA==
X-CSE-MsgGUID: 48vcbSD2SMKSogJoKN890w==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1249171"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1249171"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:35 -0700
X-CSE-ConnectionGUID: ZQFUBvBxSXe0qvf94/CIYQ==
X-CSE-MsgGUID: nrn2Yl3+QSaJOAClvKBIEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2989968"
Received: from vcostago-desk1.jf.intel.com (HELO [10.98.24.84]) ([10.98.24.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:35 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH 0/4] crypto: iaa - rework the WQ selection tables
Date: Mon, 19 Oct 2026 16:06:19 -0700
Message-Id: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMSQ6DMAxA0asgr2sppkCHq6AuktRQVxVDnE5C3
 J0Ay7f4fwLlIKxwzSYI/BGVvkugQwb+YbuWUe7JkJu8ImPOKNaiD/8h9vgdMVr3YsWCywsRFUd
 DJ0jpELiR37atb7v17Z7s4/qCeV4Af7Ew0XgAAAA=
X-Change-ID: 20261008-iaa-crypto-wq-tables-4e5911143017
To: Kristen Accardi <kristen.c.accardi@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
X-Mailer: b4 0.17-dev-6be7c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792451190; l=1515;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=SmF3Ilp5Gj/wTCaoZJEP+WS0uyo4jMKUdrQfhjNUfTU=;
 b=Ij9JPqufnXAL+py/Q+bzVPeqqUcBwyl5sHLccJkVfGnlshtWDGJRs4CfoOfCFdWVvytc0ae4d
 bwbq3Du27qjA22sH7quxOSX7FzJdNwN2BoXkrOdX9xghA4yrbqXQF5q
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

iaa_crypto maps each CPU to a single IAA device through a flat CPU
index, which ignores packages (where the actual IAA devices live) and
leaves other IAA devices in the package idle.

Patches 1-2 make the request carry the IAA workqueue
representation ('iaa_wq') it holds a reference on, instead of looking
it up again. Patch 3 replaces the per-CPU WQ table with per-package
tables published with RCU, and patch 4 keeps each CPU on one WQ for
decompression.

Patches 1-3 are meant more of a simplification, to make the code
easier to reason about. Patch 4 is "low hanging" optimization (because
decompressions are very fast, they benefit when the same CPU uses the
same engine). Future work will introduce more complex optimizations.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
Vinicius Costa Gomes (4):
      crypto: iaa - carry the iaa_wq in the request
      crypto: iaa - take the WQ from the request in the submit helpers
      crypto: iaa - use RCU per-package WQ tables
      crypto: iaa - keep each CPU on one WQ for decompression

 drivers/crypto/intel/iaa/iaa_crypto.h      |   7 -
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 393 ++++++++++++-----------------
 2 files changed, 157 insertions(+), 243 deletions(-)
---
base-commit: 178aff4cf425b3fc51ff09c571fa1bfbc1eb8ea4
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
change-id: 20261008-iaa-crypto-wq-tables-4e5911143017

Best regards,
--  
Vinicius

