Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D923161A1;
	Mon, 23 Feb 2026 16:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864281; cv=none; b=rxLy011U7zPikDZShIPuIDf52mw/nCtI2CY7evthYqbt1MpbVEwepwxRpdSphnWF6OiyswqosliWCxamyROPXTK5CQFHz1AJp1N1dZsdgr7IfdC2d5DLy/yHVpzZVWqI6QbpaYoubcTgZwtpphyHIffhY2J/NLg1a7oP4zZroJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864281; c=relaxed/simple;
	bh=iSojNmc5jEvKxXWTFvXiIJ5x0/SbjJU1adUGx+WYgvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8/HUQPK2Ia7R8Kb6SUaJf2gmESnT+0MdwZ9tB5jRaquSr1ZoUXGUYqFeBkDhQSTbNxTj7mwPBrlC6eH+B2VS1o/YTFp+Qn/jXwCZGhzcfKhSjuvUF7J8pzGuDMnhVcDnqMTBLuXX0joU8KxzFOhZup4t5mWJ04BHKUIhcX+/UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXKZ9pkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXKZ9pkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A11C19423;
	Mon, 23 Feb 2026 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771864281;
	bh=iSojNmc5jEvKxXWTFvXiIJ5x0/SbjJU1adUGx+WYgvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXKZ9pknkND5W6PK+VuZ7+C6Gp81gaDe4qQzufdeE4yApsTYtYT60SCS21fp3DjH8
	 Cqg2wzEgLkr9hFHkVnd00xCYr3iEkRW3fsdptt3y/RnP5L3Ov31tb7a9ARUjv3kDV4
	 JSk3blo9T2dvPsK68C1wEAVgtJdpxV+hpWLbCJNbUT5RRa2gFskX8E0Kcb/FmCqzz4
	 ZRGuiiOJpRhSHoNxlFFX5NlwmuBlRJE0pKKEHV+8/e8k0uSVb3sHVT3DeTLJVYbhOS
	 sypCD/KlVbouhi0/xrqWA4CemAVXtYlCSplIlCJnkxgbihmGwp66mHujFOmdRJxu5i
	 HeDHY2NbHgfZQ==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 1/4] selftests/kvm: allow retrieving underlying SEV firmware error
Date: Mon, 23 Feb 2026 09:28:57 -0700
Message-ID: <20260223162900.772669-2-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260223162900.772669-1-tycho@kernel.org>
References: <20260223162900.772669-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

In addition to the errno, sometimes it is useful to know the underlying SEV
firmware error. Update the raw vm ioctl macro to allow for optionally
retrieving this.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 tools/testing/selftests/kvm/include/x86/sev.h       | 6 ++++--
 tools/testing/selftests/kvm/x86/sev_migrate_tests.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
index 008b4169f5e2..fd11f4222ec2 100644
--- a/tools/testing/selftests/kvm/include/x86/sev.h
+++ b/tools/testing/selftests/kvm/include/x86/sev.h
@@ -76,7 +76,7 @@ static inline u64 snp_default_policy(void)
  * creating an overlay to pass in an "unsigned long" without a cast (casting
  * will make the compiler unhappy due to dereferencing an aliased pointer).
  */
-#define __vm_sev_ioctl(vm, cmd, arg)					\
+#define __vm_sev_ioctl(vm, cmd, arg, errorp)				\
 ({									\
 	int r;								\
 									\
@@ -90,12 +90,14 @@ static inline u64 snp_default_policy(void)
 	} };								\
 									\
 	r = __vm_ioctl(vm, KVM_MEMORY_ENCRYPT_OP, &sev_cmd.raw);	\
+	if (errorp != NULL)						\
+		*((__u32 *)errorp) = sev_cmd.c.error;			\
 	r ?: sev_cmd.c.error;						\
 })
 
 #define vm_sev_ioctl(vm, cmd, arg)					\
 ({									\
-	int ret = __vm_sev_ioctl(vm, cmd, arg);				\
+	int ret = __vm_sev_ioctl(vm, cmd, arg, NULL);			\
 									\
 	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd,	ret, vm);		\
 })
diff --git a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
index 0a6dfba3905b..18f3091e0bd8 100644
--- a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
@@ -232,7 +232,7 @@ static void verify_mirror_allowed_cmds(struct kvm_vm *vm)
 		 * These commands should be disallowed before the data
 		 * parameter is examined so NULL is OK here.
 		 */
-		ret = __vm_sev_ioctl(vm, cmd_id, NULL);
+		ret = __vm_sev_ioctl(vm, cmd_id, NULL, NULL);
 		TEST_ASSERT(
 			ret == -1 && errno == EINVAL,
 			"Should not be able call command: %d. ret: %d, errno: %d",
-- 
2.53.0

