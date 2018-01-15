From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 0/4] KVM: SVM: kbuild test robot warning fixes
Date: Mon, 15 Jan 2018 07:32:01 -0600
Message-ID: <20180115133205.93859-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: kvm@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The patch series fixes the warnings reported by kbuild test robot
after SEV patches. Additionally, during testing I found that LAUNCH_SECRET
command was broken and patch series contains the fix for it.

The patch series applies on kvm/queue branch. 

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Brijesh Singh (4):
  crypto: ccp: Fix sparse, use plain integer as NULL pointer
  KVM: SVM: Fix sparse: incorrect type in argument 1 (different base
    types)
  include: psp-sev: Capitalize invalid length enum
  KVM: SVM: Fix SEV LAUNCH_SECRET command

 arch/x86/kvm/svm.c           | 14 ++++++++++----
 drivers/crypto/ccp/psp-dev.c |  8 ++++----
 include/uapi/linux/psp-sev.h |  2 +-
 3 files changed, 15 insertions(+), 9 deletions(-)

-- 
2.9.5
