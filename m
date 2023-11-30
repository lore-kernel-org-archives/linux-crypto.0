Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="JGicVOo6"
Received: from sonic305-22.consmr.mail.ne1.yahoo.com (sonic305-22.consmr.mail.ne1.yahoo.com [66.163.185.148])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7AC10FF
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 12:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1701377669; bh=ne8Ng3wwFV0sSDNp47bQa0X5+QEcWPxh8lp0rduKGrs=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=JGicVOo6W3oxikQfqbz6foRiMHrkrtI8Fr/XTdZ0VcCYfRHDFPOhoueJNmkaMB8Fdty/CK7gfGglh9h0WZRpAGJoan+V6Fg5pveMfZgL8PjXswOQQlib/3BYTNERRTuQsfG4udjoGtYUEh4CMypMwOb5qrdlnut2e8PoU/EHL2u9HyRIviRmUyvMiTSmrCzYA6g7kbKMxpPAWNMrdCV6DxcdLan52784L5sOuenVBltVsFka1AtA+gzXZi94+WERAuMewdGR5RkYPNhFd7NGZwAdPWhtNdvg6x8tWDKaME1Q29yfsgq3f/FixWsfbfPJruXqoxyQCrWXJ0BACHR63g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1701377669; bh=FOXWBmKcWljovWqKTntK95uyrbFs9+Kcax4hueMvFDR=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=Zlcy2MNjffmXBGWB04qQOk4ROxPN4TVIvB4qtLKjOBjulqgVbZYwhbe7NMFPqOpePDXl+jqC8xHOPzV3a4VzxO4d3vTk1BI8DD0SVzfEygbSwu++AIY9lzgXcMZHJ3LAmlnEGXkruh9Ii1GPZ7WJHmwcfWxqi764KIMfpG6+dB/rN7DCYljY9zoooi+HSJmCQ8GDVTV3mUqJ3QIJ/2bQjdEB253cBPiEXtg26o7YhC0RMF4skB8Nr3fapaYuyqlRgG03xiW6Oxl9S0uBttvDjE68oKT7xjXDNbX7NSV6BrFevWIoNC3lKYR7IM70QltyvKrl0QqVaMbY1VmVZM8QUA==
X-YMail-OSG: _wa377gVM1mosoTE5exqnYlzOM0_rLMFo6EctijfdglUiVr6JWdnN66qe6nRgne
 y.iru2UnFX_2pCwR3xFuMXTFjSU6VXF4fnrMFZQdlNHqZVFmpdCEw59lDEQwlSDkn23bRqs_fMiy
 qzOjXQjyfB3ckUgeGNCT2l5u1SiD5nw5HB2ycXbNrh.3J3r1EYs1TbC7fDQmiOckE8wsCCQyi2AY
 ZBtiwl1.xAWbj2EjdrZbyhlVRx.mmiAQYtIkAAqzj6nOezxCojjcUJwJd1q0JFppx84s2hlh2oMO
 .Bglc89qrfvOWBWplZwXCRHBWf0vIC6moHY.gxHzGbZzglCmcascH367Otn4Fz22zc8p29Gui0iV
 BIzETZXTdyVU50G5BDL8RjJWJGNhRYqfCJgYdgCBexPmK8UDaOnfUQnpaal7golGklp9.7TF.lAt
 VgB9pJXIkPQ0ozgwh_LG4XcemcAXhHjG6y1gA3RFd5kHJEaKXa5ofeJIqY5NvVlkqCeWH9wKv4EN
 bHO00_q8uqVyFkIglGz8fBOlL9tkVRQ56njF4D4CcJUqfdBLIH54uY13IfA068AZeBgrvvMp.p0u
 b7vB_pcrscimA3bXy_rjmsOtRnZC1yk32FaKETzOOBb3cUe16KPxnF447SLVhm5mMu_sjo.TqOHd
 BdahoUrXsTetaltI8i3QVO25XcZZWgIpn8r.DpM3SCU18MhV6vWVfM_vcL4FxAn6_IgOyfGZKZ3E
 bqA2d8WpYEr3ZcOdkHu2CgXwVCnCibE8FMeVsNCIpYuVVZnLTmINJBYW_jsnwHT55fAFsh8KHN0d
 RFDGG7rmj9xvJJAUEYHTu8ur3zUh6z5.yVwBlbcs6PktDAZB8S0oYfOwq6.7lt__EfapyUmlAxhL
 PA4NSxsbAVk54HtD3ujlNi0pjckzXBQpQ8uiDwnoe2kR5eB60UK2VbOe3YTkzDm.ZgzABj9L8nvw
 aJ3owUVDjqL0v32ivXT2n7ckVt7DAheZkidwZWfrslggCgF_qvz8WJEbhiJr3IklR2C7SGd4RXeM
 ClK4Tij7psGcauWfGOBjrrj._MvPMcsT_JShx5BfZ47mbHD6BajEQN9OiatY5W_npPIL_6b_CrKA
 yChgu5JiYB06P5Ay_fbxa2SquGOZAikplOFFYYxbWmiEKKmNtji_GTZyo6nJdnnm9egc7jq6NiA7
 hdVbuR_phgOl2T9KcqaVIwPPErwSXZ7sex3LanLgx_kVoVfZ5mQPQZC_83xrd0JxOuhYw13Z.Qv7
 BFNnmww6ycMoAYsYur2SvqNTS2jLgtHsCdmRX1fPCDlzfgCimgoApR_fO4JcNomUAEBpWtKu0Qib
 WQyvYfqLSYRwb_CKo1BkGrbxuDgN5TPyNUm8xKaLVtRxJTqWgHdmqn2ObHe67WwRKS55RdjDrzgF
 NeoDblMc3U3mUPkYGjKHgOZrL_MLoOW0Ul5FsqaIMgxWLGGG24y3S6KQJDWhr7LTCkgRkv_.r8ba
 LUwE5YUaT.5ljTVclJB5MzyiN6aywn0mMPs0r0vGEKkce3pROQcFaREil6wOJAKJYpiftUkaZt5v
 bD54fw2JMCJNmPRLH_M4FevBUhG_HorPaft0LdlYb3CHVuVgiFRbRLqAuibRC0xvtVIP61H9B9RS
 _GvXCmjRJyA1ucEuvEp7VXq0nh.xuv3fPn2s8XkDz1vaMJ3vQ_.Mx0ORQKpnKhzUNc1NR1mCgr71
 Pu0lD4yhO1M0zb0E6YY1v2lW6AmKbVNjDo6dVFo2HV84OfS2rTS79D5Z68Kk8rfjCemxXUu7yM42
 ulPm7gBMFrDXJsF0c5bXqWMzofaQfTDGC4kLQD.S49mVXbAn0zhnvhf1GpYxp1_AZ1BN0zz4eB7i
 Hc0xY3ULWzqFDXrf6g5fjGPG6h62EYASFAzQmsJopgXlPjF0mPK7dQ3L7nzIitj9f1BxT2Wo8pKV
 BQngqTZHhaDLovz4rCSGBlbJAGExiQMJfoT.tgbRvBY6k4RLILGP26Htot9wpIs8zbOqlsTCkLh1
 LLR.pdWgdqNTmeMejrLbr8K_fACdKyoMEK5RnF_K_OD_I81ZU5g3_YH1JoJlju3978NPmeHHjdKT
 W7RHfIYChahX0Sclxa9a5vfX3mxy14rmUifAFYCQNMhurr1mxyHoVncNBzrO6r.UwMeMUntDfPfS
 .TMsLM4wRPHzmeJGYeMi0OJ0YSUsZPNv_ttw85dv1Ae72fF6FV1rypL7knGoJDGlZkEOAhP0fhiX
 xHkwlmPkn0E2zAdnJpKoGC5aBVdkTQTukxbAQRbX5awItBbFKY1jnFhm.cgqdEPSBJJb1lzmAqxv
 MtSbMyUo-
X-Sonic-MF: <eric_devolder@yahoo.com>
X-Sonic-ID: c68a4d6e-7c9b-46cc-b3b8-770553b3962f
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Thu, 30 Nov 2023 20:54:29 +0000
Received: by hermes--production-bf1-5d8dc66654-fb2td (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 718f32cd8f139020ed74360f54b88507;
          Thu, 30 Nov 2023 20:54:27 +0000 (UTC)
Message-ID: <bf1f1a7c-6ada-47f3-83dc-fd5c77accec2@yahoo.com>
Date: Thu, 30 Nov 2023 14:54:24 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] kexec: fix KEXEC_FILE dependencies
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Vivek Goyal <vgoyal@redhat.com>,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20231023110308.1202042-1-arnd@kernel.org>
 <ZTe8NOgAjvKDA6z0@MiWiFi-R3L-srv>
 <b71034f4-5cdc-44e0-b72f-1a8ffae0593e@app.fastmail.com>
 <ZUNXxp9AIkjQkP9s@MiWiFi-R3L-srv>
 <20231130085657.6f7f500cc17b663747e4ee76@linux-foundation.org>
From: Eric DeVolder <eric_devolder@yahoo.com>
In-Reply-To: <20231130085657.6f7f500cc17b663747e4ee76@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.21896 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo


On 11/30/23 10:56, Andrew Morton wrote:
> On Thu, 2 Nov 2023 16:03:18 +0800 Baoquan He <bhe@redhat.com> wrote:
>
>>>> CONFIG_KEXEC_FILE, but still get purgatory code built in which is
>>>> totally useless.
>>>>
>>>> Not sure if I think too much over this.
>>> I see your point here, and I would suggest changing the
>>> CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY symbol to just indicate
>>> the availability of the purgatory code for the arch, rather
>>> than actually controlling the code itself. I already mentioned
>>> this for s390, but riscv would need the same thing on top.
>>>
>>> I think the change below should address your concern.
>> Since no new comment, do you mind spinning v2 to wrap all these up?
> This patchset remains in mm-hotfixes-unstable from the previous -rc
> cycle.  Eric, do you have any comments?  Arnd, do you plan on a v2?  If
> not, should I merge v1?  If so, should I now add cc:stable?

My apologies, I lost this. I've looked at these changes, and I am in 
favor of these changes.

Furthermore, I ran the following thru the Kconfig regression script, and 
did not find anything!

I believe the following patch represents the current discussion threads 
around Kconfig and KEXEC/CRASH.

Reviewed-by: Eric DeVolder <eric_devolder@yahoo.com>

Tested-by: Eric DeVolder <eric_devolder@yahoo.com>

Thanks!

eric

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6f105ee4f3cf..1f11a62809f2 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -608,10 +608,10 @@ config ARCH_SUPPORTS_KEXEC
      def_bool PPC_BOOK3S || PPC_E500 || (44x && !SMP)

  config ARCH_SUPPORTS_KEXEC_FILE
-    def_bool PPC64 && CRYPTO=y && CRYPTO_SHA256=y
+    def_bool PPC64

  config ARCH_SUPPORTS_KEXEC_PURGATORY
-    def_bool KEXEC_FILE
+    def_bool y

  config ARCH_SELECTS_KEXEC_FILE
      def_bool y
diff --git a/arch/riscv/Kbuild b/arch/riscv/Kbuild
index d25ad1c19f88..ab181d187c23 100644
--- a/arch/riscv/Kbuild
+++ b/arch/riscv/Kbuild
@@ -5,7 +5,7 @@ obj-$(CONFIG_BUILTIN_DTB) += boot/dts/
  obj-y += errata/
  obj-$(CONFIG_KVM) += kvm/

-obj-$(CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY) += purgatory/
+obj-$(CONFIG_KEXEC_FILE) += purgatory/

  # for cleaning
  subdir- += boot
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 95a2a06acc6a..98857d76e458 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -702,9 +702,7 @@ config ARCH_SELECTS_KEXEC_FILE
      select KEXEC_ELF

  config ARCH_SUPPORTS_KEXEC_PURGATORY
-    def_bool KEXEC_FILE
-    depends on CRYPTO=y
-    depends on CRYPTO_SHA256=y
+    def_bool y

  config ARCH_SUPPORTS_CRASH_DUMP
      def_bool y
diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
index e60fbd8660c4..3ac341d296db 100644
--- a/arch/riscv/kernel/elf_kexec.c
+++ b/arch/riscv/kernel/elf_kexec.c
@@ -266,7 +266,7 @@ static void *elf_kexec_load(struct kimage *image, 
char *kernel_buf,
          cmdline = modified_cmdline;
      }

-#ifdef CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY
+#ifdef CONFIG_KEXEC_FILE
      /* Add purgatory to the image */
      kbuf.top_down = true;
      kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
@@ -280,7 +280,7 @@ static void *elf_kexec_load(struct kimage *image, 
char *kernel_buf,
                           sizeof(kernel_start), 0);
      if (ret)
          pr_err("Error update purgatory ret=%d\n", ret);
-#endif /* CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY */
+#endif /* CONFIG_KEXEC_FILE */

      /* Add the initrd to the image */
      if (initrd != NULL) {
diff --git a/arch/s390/Kbuild b/arch/s390/Kbuild
index a5d3503b353c..f2ce80b65551 100644
--- a/arch/s390/Kbuild
+++ b/arch/s390/Kbuild
@@ -7,7 +7,7 @@ obj-$(CONFIG_S390_HYPFS)    += hypfs/
  obj-$(CONFIG_APPLDATA_BASE)    += appldata/
  obj-y                += net/
  obj-$(CONFIG_PCI)        += pci/
-obj-$(CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY) += purgatory/
+obj-$(CONFIG_KEXEC_FILE) += purgatory/

  # for cleaning
  subdir- += boot tools
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 3bec98d20283..d5d8f99d1f25 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -254,13 +254,13 @@ config ARCH_SUPPORTS_KEXEC
      def_bool y

  config ARCH_SUPPORTS_KEXEC_FILE
-    def_bool CRYPTO && CRYPTO_SHA256 && CRYPTO_SHA256_S390
+    def_bool y

  config ARCH_SUPPORTS_KEXEC_SIG
      def_bool MODULE_SIG_FORMAT

  config ARCH_SUPPORTS_KEXEC_PURGATORY
-    def_bool KEXEC_FILE
+    def_bool y

  config ARCH_SUPPORTS_CRASH_DUMP
      def_bool y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3762f41bb092..1566748f16c4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2072,7 +2072,7 @@ config ARCH_SUPPORTS_KEXEC
      def_bool y

  config ARCH_SUPPORTS_KEXEC_FILE
-    def_bool X86_64 && CRYPTO && CRYPTO_SHA256
+    def_bool X86_64

  config ARCH_SELECTS_KEXEC_FILE
      def_bool y
@@ -2080,7 +2080,7 @@ config ARCH_SELECTS_KEXEC_FILE
      select HAVE_IMA_KEXEC if IMA

  config ARCH_SUPPORTS_KEXEC_PURGATORY
-    def_bool KEXEC_FILE
+    def_bool y

  config ARCH_SUPPORTS_KEXEC_SIG
      def_bool y
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 7aff28ded2f4..92120e396008 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -36,6 +36,7 @@ config KEXEC
  config KEXEC_FILE
      bool "Enable kexec file based system call"
      depends on ARCH_SUPPORTS_KEXEC_FILE
+    depends on CRYPTO_SHA256=y || !ARCH_SUPPORTS_KEXEC_PURGATORY
      select KEXEC_CORE
      help
        This is new version of kexec system call. This system call is
@@ -94,10 +95,8 @@ config KEXEC_JUMP
  config CRASH_DUMP
      bool "kernel crash dumps"
      depends on ARCH_SUPPORTS_CRASH_DUMP
-    depends on ARCH_SUPPORTS_KEXEC
      select CRASH_CORE
      select KEXEC_CORE
-    select KEXEC
      help
        Generate crash dump after being started by kexec.
        This should be normally only set in special crash dump kernels

