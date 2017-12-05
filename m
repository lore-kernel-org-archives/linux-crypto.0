From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v9 17/38] crypto: ccp: Implement SEV_PDH_GEN ioctl command
Date: Mon,  4 Dec 2017 19:04:17 -0600
Message-ID: <20171205010438.5773-18-brijesh.singh@amd.com>
References: <20171205010438.5773-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: bp@alien8.de, Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171205010438.5773-1-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The SEV_PDH_GEN command is used to re-generate the Platform
Diffie-Hellman (PDH) key. The command is defined in SEV spec section
5.6.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 8aa8036023e0..fd3daf0a1176 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -333,6 +333,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_PEK_GEN:
 		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input);
 		break;
+	case SEV_PDH_GEN:
+		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
-- 
2.9.5
