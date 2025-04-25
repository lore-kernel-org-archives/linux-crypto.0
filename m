Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEDD25C706
	for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745594385; cv=none; b=VCnt2548E7Z13SItWa5GuzHIMi5Wt5lga8k5dApcRn/uBldCVQaqHagW6MPT2z9CEE4BA8ubjYKNHFodbmsZoJBRix11Tw6XxVhtnhKZUcy/Ci58h7slucTkHcZflY0rGUmgTr7xeZQGsrYFDyAz8V6NIWjS3I8Y9SWN68XCg9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745594385; c=relaxed/simple;
	bh=PvDrUFHjDUHvp5TkD12uclyUV8niwHjH26SlBPihxRA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ny6r4rSwpSw2V3kIytIs+ys9vF+xKLEUWuTtFQ0aQbYASmz5ffV2eK8NU4SZ/ZGMW89WjCYbLKEW6GK+G4vgwoVDBMyR1FlPYpSaojzP2bpO7cbZ4Qx+TMLEnitmIe+nh+3TifIlvPIjrMMfzEB/LqwXHhdSwh3ssTGMzbbZ9Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=obea4SBm; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=LHw+s5pp; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="obea4SBm";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="LHw+s5pp"
Date: Fri, 25 Apr 2025 17:19:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1745594381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lPYqX3Dbdud1Eleh/Ez5i0QGNn0vsw/EiO2gLxI9+tw=;
	b=obea4SBmA+ulif1C+OyNFLzdkEzzL2wkeg+S5GQcmL8WguvWPIKfRAIOEgLBXHcop5n5Pm
	cS0/JecCF6jw4Xd6XpV4HG4lQEHlkhJNi7Li1A2QFuuryDxHRM9EC6wqQPziF3gOXdeDQF
	qyjbmaAuAHmsiro8R/LaVDOvSWeemgbqcDE1YQpfONBA3nHSBYful/IaMra5vO13OHVEN0
	7Q1FyzQx4fMtmYz+0+wCBwDzlhjIilsYWqlRVVH/DTJFwsyxtifJTpxHsmTvsBUYWmS/E9
	fiTq+tz749qXNHpZ2lJT7B23ATVPnFNtsii/MEmLMU2DjARcn47gA5r/0pQ5GQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1745594381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lPYqX3Dbdud1Eleh/Ez5i0QGNn0vsw/EiO2gLxI9+tw=;
	b=LHw+s5pp04UfeVPOtB26lTzCyWbNLiArLp+sg/SEngd9MGZWVJeVVemRB3fx+ixJWkErIq
	WGvNUBuFHDHZ2XBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: linux-crypto@vger.kernel.org, tglx@linutronix.de
Subject: [RFC] Looking at the IAA driver
Message-ID: <20250425151940.Bd_TKH82@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've been staring at the crypto IAA driver and checking if "wq_table"
relies on disabling bottom halves/ expecting that softirq is not
preemtible. It does not look like it does. wq_table_next_wq() returns a
"struct idxd_wq *" which could return twice the same but the struct
itself has its own locking which looks fine.
Please correct me if I am wrong ;)

While looking at it, I noticed a few other things:

- wq_table
  This could be initialized as DEFINE_PER_CPU() instead the
  alloc_percpu() it has now. I see no benefit from delaying it. The
  driver is loaded on its own once the dmaengine counterpart is loaded
  first and added the special bus plus the device. So the allocation
  could be avoided.

- nr_cpus, nr_nodes, nr_cpus_per_node.
  This is derived from
   - nr_cpus =3D num_possible_cpus();
   - for_each_node_with_cpus(node) nr_nodes++;
   - nr_cpus_per_node =3D nr_cpus / nr_nodes;

   Moving on. nr_cpus_per_node is only used as
       cpus_per_iaa =3D (nr_nodes * nr_cpus_per_node) / nr_iaa;

   Given the above definition for nr_cpus_per_node we can substitute
       cpus_per_iaa =3D nr_cpus / nr_iaa

   and then remove nr_cpus_per_node as I see no other user. If we ignore
   the one pr_debug() then we could also remove nr_nodes because there
   are no users.

   There are several iterations which go from 0 to nr_nodes. I would
   recommend using for_each_possible_cpu(). Then nr_cpus could be
   removed.

- wq_table->wqs
  This is allocated as (max_wqs * sizeof(struct wq *)). I don't know
  where "struct wq" is from but it is not "struct idxd_wq" and gcc
  probably doesn't care because it is a pointer. Also the memory for the
  per-CPU memory is allocated always from the _current_ NUMA node. Not
  bad but also not ideal.
  How huge can max_wqs can get? If it is, say 64, then you could make a
  fix array of 64 which is part of struct wq_table_entry and avoid the
  allocation.=20
  Another variant would be to do something like
   struct wq_table_entry {
         int     max_wqs;
         int     n_wqs;
         int     cur_wq;
         struct idxd_wq wqs[];
   };
   and then
       wq_table =3D alloc_percpu(struct_size(wq_table, wqs, max_wqs));

   voil=C3=A0.
   I didn't figure out how the final struct idxd_wq is allocated but it
   would make sense to allocate it node local the CPU if possible.

Sebastian
