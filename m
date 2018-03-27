From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 08/10] kbuild: rename *-asn1.[ch] to *.asn.[ch]
Date: Tue, 27 Mar 2018 15:06:06 +0900
Message-ID: <CAK7LNAS-v4WwOaYHnWUWLxVNiO5p4caZSTp5JJWf5=uV3BQSuA@mail.gmail.com>
References: <1521810279-6282-1-git-send-email-yamada.masahiro@socionext.com> <1521810279-6282-8-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Frank Rowand <frank.rowand@sony.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-crypto@vger.kernel.org
To: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521810279-6282-8-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

+CC linux-crypto@vger.kernel.org

No functional change, though.

(I fixed up the subject.)


2018-03-23 22:04 GMT+09:00 Masahiro Yamada <yamada.masahiro@socionext.com>:
> Our convention is to distinguish file types by suffixes with a period
> as a separator.
>
> *-asn1.[ch] is a different pattern from other generated sources such
> as *.lex.c, *.tab.[ch], *.dtb.S, etc.  More confusing, files with
> '-asn1.[ch]' are generated files, but '_asn1.[ch]' are checked-in
> files:
>   net/netfilter/nf_conntrack_h323_asn1.c
>   include/linux/netfilter/nf_conntrack_h323_asn1.h
>   include/linux/sunrpc/gss_asn1.h
>
> Rename generated files to *.asn1.[ch] for consistency.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
>
>  .gitignore                                  |  2 +-
>  Makefile                                    |  2 +-
>  crypto/Makefile                             | 10 +++++-----
>  crypto/asymmetric_keys/Makefile             | 24 ++++++++++++------------
>  crypto/asymmetric_keys/mscode_parser.c      |  2 +-
>  crypto/asymmetric_keys/pkcs7_parser.c       |  2 +-
>  crypto/asymmetric_keys/x509_cert_parser.c   |  4 ++--
>  crypto/rsa_helper.c                         |  4 ++--
>  net/ipv4/netfilter/Makefile                 |  4 ++--
>  net/ipv4/netfilter/nf_nat_snmp_basic_main.c |  2 +-
>  scripts/Makefile.build                      |  4 ++--
>  scripts/asn1_compiler.c                     |  2 +-
>  12 files changed, 31 insertions(+), 31 deletions(-)
>
> diff --git a/.gitignore b/.gitignore
> index a7fef34..1c8189e 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -11,7 +11,7 @@
>  #
>  .*
>  *.a
> -*-asn1.[ch]
> +*.asn1.[ch]
>  *.bin
>  *.bz2
>  *.c.[012]*.*
> diff --git a/Makefile b/Makefile
> index 054f43a..702f154 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1614,7 +1614,7 @@ clean: $(clean-dirs)
>                 -o -name '*.su'  \
>                 -o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
>                 -o -name '*.lex.c' -o -name '*.tab.[ch]' \
> -               -o -name '*-asn1.[ch]' \
> +               -o -name '*.asn1.[ch]' \
>                 -o -name '*.symtypes' -o -name 'modules.order' \
>                 -o -name modules.builtin -o -name '.tmp_*.o.*' \
>                 -o -name .cache.mk \
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 4eae4da..9be77d0 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -35,12 +35,12 @@ dh_generic-y := dh.o
>  dh_generic-y += dh_helper.o
>  obj-$(CONFIG_CRYPTO_DH) += dh_generic.o
>
> -$(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
> -$(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
> -$(obj)/rsa_helper.o: $(obj)/rsapubkey-asn1.h $(obj)/rsaprivkey-asn1.h
> +$(obj)/rsapubkey.asn1.o: $(obj)/rsapubkey.asn1.c $(obj)/rsapubkey.asn1.h
> +$(obj)/rsaprivkey.asn1.o: $(obj)/rsaprivkey.asn1.c $(obj)/rsaprivkey.asn1.h
> +$(obj)/rsa_helper.o: $(obj)/rsapubkey.asn1.h $(obj)/rsaprivkey.asn1.h
>
> -rsa_generic-y := rsapubkey-asn1.o
> -rsa_generic-y += rsaprivkey-asn1.o
> +rsa_generic-y := rsapubkey.asn1.o
> +rsa_generic-y += rsaprivkey.asn1.o
>  rsa_generic-y += rsa.o
>  rsa_generic-y += rsa_helper.o
>  rsa_generic-y += rsa-pkcs1pad.o
> diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
> index bd8ed09..d4b2e1b 100644
> --- a/crypto/asymmetric_keys/Makefile
> +++ b/crypto/asymmetric_keys/Makefile
> @@ -17,30 +17,30 @@ obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
>  #
>  obj-$(CONFIG_X509_CERTIFICATE_PARSER) += x509_key_parser.o
>  x509_key_parser-y := \
> -       x509-asn1.o \
> -       x509_akid-asn1.o \
> +       x509.asn1.o \
> +       x509_akid.asn1.o \
>         x509_cert_parser.o \
>         x509_public_key.o
>
>  $(obj)/x509_cert_parser.o: \
> -       $(obj)/x509-asn1.h \
> -       $(obj)/x509_akid-asn1.h
> +       $(obj)/x509.asn1.h \
> +       $(obj)/x509_akid.asn1.h
>
> -$(obj)/x509-asn1.o: $(obj)/x509-asn1.c $(obj)/x509-asn1.h
> -$(obj)/x509_akid-asn1.o: $(obj)/x509_akid-asn1.c $(obj)/x509_akid-asn1.h
> +$(obj)/x509.asn1.o: $(obj)/x509.asn1.c $(obj)/x509.asn1.h
> +$(obj)/x509_akid.asn1.o: $(obj)/x509_akid.asn1.c $(obj)/x509_akid.asn1.h
>
>  #
>  # PKCS#7 message handling
>  #
>  obj-$(CONFIG_PKCS7_MESSAGE_PARSER) += pkcs7_message.o
>  pkcs7_message-y := \
> -       pkcs7-asn1.o \
> +       pkcs7.asn1.o \
>         pkcs7_parser.o \
>         pkcs7_trust.o \
>         pkcs7_verify.o
>
> -$(obj)/pkcs7_parser.o: $(obj)/pkcs7-asn1.h
> -$(obj)/pkcs7-asn1.o: $(obj)/pkcs7-asn1.c $(obj)/pkcs7-asn1.h
> +$(obj)/pkcs7_parser.o: $(obj)/pkcs7.asn1.h
> +$(obj)/pkcs7.asn1.o: $(obj)/pkcs7.asn1.c $(obj)/pkcs7.asn1.h
>
>  #
>  # PKCS#7 parser testing key
> @@ -57,7 +57,7 @@ obj-$(CONFIG_SIGNED_PE_FILE_VERIFICATION) += verify_signed_pefile.o
>  verify_signed_pefile-y := \
>         verify_pefile.o \
>         mscode_parser.o \
> -       mscode-asn1.o
> +       mscode.asn1.o
>
> -$(obj)/mscode_parser.o: $(obj)/mscode-asn1.h $(obj)/mscode-asn1.h
> -$(obj)/mscode-asn1.o: $(obj)/mscode-asn1.c $(obj)/mscode-asn1.h
> +$(obj)/mscode_parser.o: $(obj)/mscode.asn1.h $(obj)/mscode.asn1.h
> +$(obj)/mscode.asn1.o: $(obj)/mscode.asn1.c $(obj)/mscode.asn1.h
> diff --git a/crypto/asymmetric_keys/mscode_parser.c b/crypto/asymmetric_keys/mscode_parser.c
> index 9492e1c..83d2e9b 100644
> --- a/crypto/asymmetric_keys/mscode_parser.c
> +++ b/crypto/asymmetric_keys/mscode_parser.c
> @@ -16,7 +16,7 @@
>  #include <linux/oid_registry.h>
>  #include <crypto/pkcs7.h>
>  #include "verify_pefile.h"
> -#include "mscode-asn1.h"
> +#include "mscode.asn1.h"
>
>  /*
>   * Parse a Microsoft Individual Code Signing blob
> diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
> index a6dcaa6..0f13416 100644
> --- a/crypto/asymmetric_keys/pkcs7_parser.c
> +++ b/crypto/asymmetric_keys/pkcs7_parser.c
> @@ -18,7 +18,7 @@
>  #include <linux/oid_registry.h>
>  #include <crypto/public_key.h>
>  #include "pkcs7_parser.h"
> -#include "pkcs7-asn1.h"
> +#include "pkcs7.asn1.h"
>
>  MODULE_DESCRIPTION("PKCS#7 parser");
>  MODULE_AUTHOR("Red Hat, Inc.");
> diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
> index ce2df8c..7d81e6b 100644
> --- a/crypto/asymmetric_keys/x509_cert_parser.c
> +++ b/crypto/asymmetric_keys/x509_cert_parser.c
> @@ -17,8 +17,8 @@
>  #include <linux/oid_registry.h>
>  #include <crypto/public_key.h>
>  #include "x509_parser.h"
> -#include "x509-asn1.h"
> -#include "x509_akid-asn1.h"
> +#include "x509.asn1.h"
> +#include "x509_akid.asn1.h"
>
>  struct x509_parse_context {
>         struct x509_certificate *cert;          /* Certificate being constructed */
> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
> index cad395d..efc78fe 100644
> --- a/crypto/rsa_helper.c
> +++ b/crypto/rsa_helper.c
> @@ -15,8 +15,8 @@
>  #include <linux/err.h>
>  #include <linux/fips.h>
>  #include <crypto/internal/rsa.h>
> -#include "rsapubkey-asn1.h"
> -#include "rsaprivkey-asn1.h"
> +#include "rsapubkey.asn1.h"
> +#include "rsaprivkey.asn1.h"
>
>  int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
>               const void *value, size_t vlen)
> diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
> index e5f5638..f37efa3 100644
> --- a/net/ipv4/netfilter/Makefile
> +++ b/net/ipv4/netfilter/Makefile
> @@ -28,8 +28,8 @@ obj-$(CONFIG_NF_REJECT_IPV4) += nf_reject_ipv4.o
>  obj-$(CONFIG_NF_NAT_H323) += nf_nat_h323.o
>  obj-$(CONFIG_NF_NAT_PPTP) += nf_nat_pptp.o
>
> -nf_nat_snmp_basic-y := nf_nat_snmp_basic-asn1.o nf_nat_snmp_basic_main.o
> -nf_nat_snmp_basic-y : nf_nat_snmp_basic-asn1.h nf_nat_snmp_basic-asn1.c
> +nf_nat_snmp_basic-y := nf_nat_snmp_basic.asn1.o nf_nat_snmp_basic_main.o
> +nf_nat_snmp_basic-y : nf_nat_snmp_basic.asn1.h nf_nat_snmp_basic.asn1.c
>  obj-$(CONFIG_NF_NAT_SNMP_BASIC) += nf_nat_snmp_basic.o
>
>  obj-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
> diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
> index b6e2770..ac110c1 100644
> --- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
> +++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
> @@ -54,7 +54,7 @@
>  #include <net/netfilter/nf_conntrack_expect.h>
>  #include <net/netfilter/nf_conntrack_helper.h>
>  #include <linux/netfilter/nf_conntrack_snmp.h>
> -#include "nf_nat_snmp_basic-asn1.h"
> +#include "nf_nat_snmp_basic.asn1.h"
>
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 15b3bbb..8c3ca61 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -430,9 +430,9 @@ quiet_cmd_asn1_compiler = ASN.1   $@
>        cmd_asn1_compiler = $(objtree)/scripts/asn1_compiler $< \
>                                 $(subst .h,.c,$@) $(subst .c,.h,$@)
>
> -.PRECIOUS: $(objtree)/$(obj)/%-asn1.c $(objtree)/$(obj)/%-asn1.h
> +.PRECIOUS: $(objtree)/$(obj)/%.asn1.c $(objtree)/$(obj)/%.asn1.h
>
> -$(obj)/%-asn1.c $(obj)/%-asn1.h: $(src)/%.asn1 $(objtree)/scripts/asn1_compiler
> +$(obj)/%.asn1.c $(obj)/%.asn1.h: $(src)/%.asn1 $(objtree)/scripts/asn1_compiler
>         $(call cmd,asn1_compiler)
>
>  # Build the compiled-in targets
> diff --git a/scripts/asn1_compiler.c b/scripts/asn1_compiler.c
> index c1b7ef3..c146020 100644
> --- a/scripts/asn1_compiler.c
> +++ b/scripts/asn1_compiler.c
> @@ -1319,7 +1319,7 @@ static void render(FILE *out, FILE *hdr)
>         fprintf(out, " * ASN.1 parser for %s\n", grammar_name);
>         fprintf(out, " */\n");
>         fprintf(out, "#include <linux/asn1_ber_bytecode.h>\n");
> -       fprintf(out, "#include \"%s-asn1.h\"\n", grammar_name);
> +       fprintf(out, "#include \"%s.asn1.h\"\n", grammar_name);
>         fprintf(out, "\n");
>         if (ferror(out)) {
>                 perror(outputname);
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Masahiro Yamada
